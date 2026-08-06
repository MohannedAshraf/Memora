import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../bloc/invitations_cubit.dart';
import '../bloc/invitations_state.dart';
import '../widgets/invitation_card.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvitationsCubit>()..loadInvitations(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Invitations"), centerTitle: true),
        body: BlocBuilder<InvitationsCubit, InvitationsState>(
          builder: (context, state) {
            if (state is InvitationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InvitationsFailure) {
              return Center(child: Text(state.message));
            }

            if (state is InvitationsLoaded) {
              if (state.invitations.isEmpty) {
                return const Center(child: Text("No Pending Invitations"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<InvitationsCubit>().loadInvitations();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(18.w),
                  itemCount: state.invitations.length,
                  itemBuilder: (_, index) {
                    final invitation = state.invitations[index];

                    return InvitationCard(
                      albumTitle: invitation.title,
                      email: invitation.invitedBy,
                      createdAt: invitation.createdAt,

                      onAccept: () {
                        context.read<InvitationsCubit>().accept(invitation.id);
                      },

                      onDecline: () {
                        context.read<InvitationsCubit>().decline(invitation.id);
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
