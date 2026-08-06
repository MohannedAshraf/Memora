import 'package:memora/features/invitations/domain/repo/invitations_repository.dart';

import '../entities/invitation_entity.dart';

class GetPendingInvitationsUseCase {
  final InvitationsRepository repository;

  GetPendingInvitationsUseCase(this.repository);

  Future<List<InvitationEntity>> call() {
    return repository.getPendingInvitations();
  }
}
