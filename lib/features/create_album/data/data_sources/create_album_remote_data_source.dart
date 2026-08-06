import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/create_album_model.dart';

abstract class CreateAlbumRemoteDataSource {
  Future<void> createAlbum(CreateAlbumModel model);
}

class CreateAlbumRemoteDataSourceImpl implements CreateAlbumRemoteDataSource {
  final SupabaseClient client;

  CreateAlbumRemoteDataSourceImpl(this.client);

  @override
  Future<void> createAlbum(CreateAlbumModel model) async {
    //---------------------------------------
    // Create Album
    //---------------------------------------

    final albumId = await client.rpc(
      "create_album",
      params: {"p_title": model.title, "p_description": model.description},
    );

    //---------------------------------------
    // Upload Cover
    //---------------------------------------

    if (model.coverImage != null) {
      await _uploadCover(albumId.toString(), model.coverImage!);
    }

    //---------------------------------------
    // Send Invitations
    //---------------------------------------

    for (final invitation in model.invitations) {
      await client.rpc(
        "send_album_invitation",
        params: {
          "p_album_id": albumId,
          "p_email": invitation.email,
          "p_role": invitation.role.name,
        },
      );
    }
  }

  Future<void> _uploadCover(String albumId, File image) async {
    final extension = image.path.split('.').last;

    final response = await client.rpc(
      "create_photo_record",
      params: {
        "p_album_id": albumId,
        "p_extension": extension,
        "p_caption": null,
      },
    );

    final photo = (response as List).first;

    final photoId = photo["photo_id"];

    final storagePath = photo["storage_path"];

    await client.storage
        .from("album-photos")
        .upload(
          storagePath,
          image,
          fileOptions: const FileOptions(upsert: true),
        );

    await client.rpc(
      "set_album_cover",
      params: {"p_album_id": albumId, "p_photo_id": photoId},
    );
  }
}
