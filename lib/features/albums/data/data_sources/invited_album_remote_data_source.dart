import 'package:memora/features/albums/data/models/invited_album_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class InvitedAlbumsRemoteDataSource {
  Future<List<InvitedAlbumModel>> getInvitedAlbums();
}
class InvitedAlbumsRemoteDataSourceImpl
    implements InvitedAlbumsRemoteDataSource {
  final SupabaseClient client;

  InvitedAlbumsRemoteDataSourceImpl(this.client);

  @override
  Future<List<InvitedAlbumModel>> getInvitedAlbums() async {
    final user = client.auth.currentUser!;

    final members = await client
        .from("album_members")
        .select("album_id, role")
        .eq("user_id", user.id);

    final albumIds = members
        .where((e) => e["role"] != "owner")
        .map((e) => e["album_id"])
        .toList();

    if (albumIds.isEmpty) {
      return [];
    }

    final response = await client
        .from("albums")
        .select()
        .inFilter("id", albumIds);

    return (response as List)
        .map((e) => InvitedAlbumModel.fromJson(e))
        .toList();
  }
}
