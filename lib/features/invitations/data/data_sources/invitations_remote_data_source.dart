import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/invitation_model.dart';

abstract class InvitationsRemoteDataSource {
  Future<List<InvitationModel>> getPendingInvitations();

  Future<void> acceptInvitation(String invitationId);

  Future<void> declineInvitation(String invitationId);
}

class InvitationsRemoteDataSourceImpl implements InvitationsRemoteDataSource {
  final SupabaseClient client;

  InvitationsRemoteDataSourceImpl(this.client);

  @override
  Future<List<InvitationModel>> getPendingInvitations() async {
    final user = client.auth.currentUser!;

    final response = await client
        .from("album_invitations")
        .select("""
          id,
          album_id,
          role,
          created_at,
          albums!album_invitations_album_id_fkey(
            title,
            description
          ),
          profiles!album_invitations_invited_by_fkey(
            email
          )
        """)
        .eq("invited_user", user.id)
        .eq("status", "pending")
        .order("created_at", ascending: false);

    // ignore: avoid_print
    print(response);

    return (response as List).map((e) => InvitationModel.fromJson(e)).toList();
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    await client.rpc(
      "accept_album_invitation",
      params: {"p_invitation_id": invitationId},
    );
  }

  @override
  Future<void> declineInvitation(String invitationId) async {
    await client.rpc(
      "decline_album_invitation",
      params: {"p_invitation_id": invitationId},
    );
  }
}
