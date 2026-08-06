import 'package:memora/features/invitations/domain/repo/invitations_repository.dart';


class DeclineInvitationUseCase {
  final InvitationsRepository repository;

  DeclineInvitationUseCase(this.repository);

  Future<void> call(String invitationId) {
    return repository.declineInvitation(invitationId);
  }
}
