import '../entities/invitation_entity.dart';

abstract class InvitationsRepository {
  Future<List<InvitationEntity>> getPendingInvitations();

  Future<void> acceptInvitation(String invitationId);

  Future<void> declineInvitation(String invitationId);
}
