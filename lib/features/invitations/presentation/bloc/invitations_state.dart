import 'package:equatable/equatable.dart';

import '../../domain/entities/invitation_entity.dart';

abstract class InvitationsState extends Equatable {
  const InvitationsState();

  @override
  List<Object?> get props => [];
}

class InvitationsInitial extends InvitationsState {}

class InvitationsLoading extends InvitationsState {}

class InvitationsLoaded extends InvitationsState {
  final List<InvitationEntity> invitations;

  const InvitationsLoaded(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class InvitationsFailure extends InvitationsState {
  final String message;

  const InvitationsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
