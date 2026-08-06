import 'package:memora/features/invitations/domain/repo/invitations_repository.dart';


class AcceptInvitationUseCase {
  final InvitationsRepository repository;

  AcceptInvitationUseCase(this.repository);

  Future<void> call(String invitationId) {
    return repository.acceptInvitation(invitationId);
  }
}
