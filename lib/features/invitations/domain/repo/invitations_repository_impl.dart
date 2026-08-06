import 'package:memora/features/invitations/data/data_sources/invitations_remote_data_source.dart';
import 'package:memora/features/invitations/domain/entities/invitation_entity.dart';
import 'package:memora/features/invitations/domain/repo/invitations_repository.dart';

class InvitationsRepositoryImpl implements InvitationsRepository {
  final InvitationsRemoteDataSource remote;

  InvitationsRepositoryImpl(this.remote);

  @override
  Future<List<InvitationEntity>> getPendingInvitations() {
    return remote.getPendingInvitations();
  }

  @override
  Future<void> acceptInvitation(String invitationId) {
    return remote.acceptInvitation(invitationId);
  }

  @override
  Future<void> declineInvitation(String invitationId) {
    return remote.declineInvitation(invitationId);
  }
}
