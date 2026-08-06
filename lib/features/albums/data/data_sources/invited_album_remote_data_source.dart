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

    final invitations = await client
        .from("album_invitations")
        .select("album_id")
        .eq("invited_user", user.id)
        .eq("status", "accepted");

    final albumIds = invitations.map((e) => e["album_id"]).toList();

   if (albumIds.isEmpty) {
      return [];
    }

    final response = await client
        .from("albums")
        .select()
        .inFilter("id", albumIds)
        .order("updated_at", ascending: false);

    return (response as List)
        .map((e) => InvitedAlbumModel.fromJson(e))
        .toList();
  }
}
