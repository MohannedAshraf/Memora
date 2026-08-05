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
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    String? coverPhotoPath;

    //---------------------------------------
    // Upload Cover Image
    //---------------------------------------

    if (model.coverImage != null) {
      final extension = model.coverImage!.path.split('.').last;

      final fileName =
          "covers/${DateTime.now().millisecondsSinceEpoch}.$extension";

      await client.storage
          .from("album-photos")
          .upload(
            fileName,
            File(model.coverImage!.path),
            fileOptions: const FileOptions(upsert: true),
          );

      coverPhotoPath = fileName;
    }

    //---------------------------------------
    // Create Album
    //---------------------------------------

    final album = await client
        .from("albums")
        .insert({
          "title": model.title,
          "description": model.description,
          "owner_id": user.id,
          "cover_photo_id": coverPhotoPath,
        })
        .select()
        .single();

    final albumId = album["id"];

    //---------------------------------------
    // Add Owner
    //---------------------------------------

    await client.from("album_members").insert({
      "album_id": albumId,
      "user_id": user.id,
      "role": "owner",
    });

    //---------------------------------------
    // Invite Members
    //---------------------------------------

    if (model.invitedEmails.isNotEmpty) {
      final profiles = await client
          .from("profiles")
          .select("id,email")
          .inFilter("email", model.invitedEmails);

      if (profiles.isNotEmpty) {
        final members = (profiles as List)
            .map(
              (e) => {
                "album_id": albumId,
                "user_id": e["id"],
                "role": "member",
              },
            )
            .toList();

        await client.from("album_members").insert(members);
      }
    }
  }
}
