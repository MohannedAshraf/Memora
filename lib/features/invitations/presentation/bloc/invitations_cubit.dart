import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/accept_invitation_usecase.dart';
import '../../domain/usecases/decline_invitation_usecase.dart';
import '../../domain/usecases/get_pending_invitations_usecase.dart';
import 'invitations_state.dart';

class InvitationsCubit extends Cubit<InvitationsState> {
  final GetPendingInvitationsUseCase getPendingInvitationsUseCase;
  final AcceptInvitationUseCase acceptInvitationUseCase;
  final DeclineInvitationUseCase declineInvitationUseCase;

  InvitationsCubit(
    this.getPendingInvitationsUseCase,
    this.acceptInvitationUseCase,
    this.declineInvitationUseCase,
  ) : super(InvitationsInitial());

  Future<void> loadInvitations() async {
    emit(InvitationsLoading());

    try {
      final invitations = await getPendingInvitationsUseCase();

      emit(InvitationsLoaded(invitations));
    } catch (e) {
      emit(InvitationsFailure(e.toString()));
    }
  }

  Future<void> accept(String invitationId) async {
    try {
      await acceptInvitationUseCase(invitationId);

      await loadInvitations();
    } catch (e) {
      emit(InvitationsFailure(e.toString()));
    }
  }

  Future<void> decline(String invitationId) async {
    try {
      await declineInvitationUseCase(invitationId);

      await loadInvitations();
    } catch (e) {
      emit(InvitationsFailure(e.toString()));
    }
  }
}
