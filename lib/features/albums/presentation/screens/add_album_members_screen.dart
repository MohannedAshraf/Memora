// ignore_for_file: deprecated_member_use, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/features/albums/presentation/bloc/add_album_members_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/add_album_members_state.dart';
import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';
import 'package:memora/features/create_album/domain/entities/member_role.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app-colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';



class AddAlbumMembersScreen extends StatefulWidget {
  const AddAlbumMembersScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  final String albumId;
  final String albumTitle;

  @override
  State<AddAlbumMembersScreen> createState() => _AddAlbumMembersScreenState();
}

class _AddAlbumMembersScreenState extends State<AddAlbumMembersScreen> {
  final _emailController = TextEditingController();

  MemberRole selectedRole = MemberRole.viewer;

  final List<AlbumInvitationEntity> invitations = [];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD INVITATION
  // ============================================================

  void _addInvitation() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      return;
    }

    final exists = invitations.any(
      (invitation) => invitation.email.toLowerCase() == email.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This member has already been added')),
      );

      return;
    }

    setState(() {
      invitations.add(AlbumInvitationEntity(email: email, role: selectedRole));

      _emailController.clear();

      selectedRole = MemberRole.viewer;
    });
  }

  // ============================================================
  // REMOVE INVITATION
  // ============================================================

  void _removeInvitation(AlbumInvitationEntity invitation) {
    setState(() {
      invitations.remove(invitation);
    });
  }

  // ============================================================
  // ADD MEMBERS
  // ============================================================

  void _addMembers(BuildContext blocContext) {
    if (invitations.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(content: Text('Please add at least one member')),
      );

      return;
    }

    blocContext.read<AddAlbumMembersCubit>().addMembers(
      albumId: widget.albumId,
      invitations: invitations,
    );
  }
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddAlbumMembersCubit>(),
      child: BlocConsumer<AddAlbumMembersCubit, AddAlbumMembersState>(
        listener: (context, state) {
          // --------------------------------------------------------
          // SUCCESS
          // --------------------------------------------------------

          if (state is AddAlbumMembersSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Members added successfully')),
            );

            Navigator.of(context).pop(true);
          }

          // --------------------------------------------------------
          // FAILURE
          // --------------------------------------------------------

          if (state is AddAlbumMembersFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AddAlbumMembersLoading;

          return Scaffold(
            backgroundColor: AppColors.background,

            // ======================================================
            // APP BAR
            // ======================================================
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,

              leading: const BackButton(),

              centerTitle: true,

              title: Text(
                'Add Members',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // ======================================================
            // BODY
            // ======================================================
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.all(20.w),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------
                    // ALBUM TITLE
                    // ------------------------------------------------
                    Text(
                      widget.albumTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      'Add people to this album',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ------------------------------------------------
                    // EMAIL
                    // ------------------------------------------------
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Invite by Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (_) => null,
                    ),

                    SizedBox(height: 22.h),

                    // ------------------------------------------------
                    // ROLE
                    // ------------------------------------------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Member Role',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              SizedBox(height: 6.h),

                              // VIEWER
                              RadioListTile<MemberRole>(
                                value: MemberRole.viewer,
                                groupValue: selectedRole,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Viewer'),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        if (value == null) {
                                          return;
                                        }

                                        setState(() {
                                          selectedRole = value;
                                        });
                                      },
                              ),

                              // EDITOR
                              RadioListTile<MemberRole>(
                                value: MemberRole.editor,
                                groupValue: selectedRole,
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Editor'),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        if (value == null) {
                                          return;
                                        }

                                        setState(() {
                                          selectedRole = value;
                                        });
                                      },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // ------------------------------------------------
                        // ADD BUTTON
                        // ------------------------------------------------
                        Padding(
                          padding: EdgeInsets.only(top: 28.h),

                          child: IconButton(
                            onPressed: isLoading ? null : _addInvitation,

                            icon: Icon(
                              Icons.add_circle_rounded,
                              color: isLoading
                                  ? AppColors.textHint
                                  : AppColors.primary,
                              size: 42.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ==================================================
                    // MEMBERS LIST
                    // ==================================================
                    if (invitations.isNotEmpty) ...[
                      SizedBox(height: 16.h),

                      Text(
                        'Members to add',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Column(
                        children: invitations.map((invitation) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),

                            child: _InvitationCard(
                              invitation: invitation,
                              onRemove: isLoading
                                  ? null
                                  : () => _removeInvitation(invitation),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    SizedBox(height: 30.h),

                    // ==================================================
                    // ADD MEMBERS BUTTON
                    // ==================================================
                    AppButton(
                      text: 'Add Members',
                      isLoading: isLoading,
                     onPressed: isLoading ? null : () => _addMembers(context),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================================================================
// INVITATION CARD
// ==================================================================

class _InvitationCard extends StatelessWidget {
  const _InvitationCard({required this.invitation, required this.onRemove});

  final AlbumInvitationEntity invitation;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final isEditor = invitation.role == MemberRole.editor;

    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),

      child: Row(
        children: [
          // ----------------------------------------------------------
          // ICON
          // ----------------------------------------------------------
          Container(
            width: 42.w,
            height: 42.w,

            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
            ),

            child: Icon(
              isEditor ? Icons.edit_outlined : Icons.visibility_outlined,

              color: AppColors.primary,
              size: 21.sp,
            ),
          ),

          SizedBox(width: 12.w),

          // ----------------------------------------------------------
          // EMAIL + ROLE
          // ----------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  isEditor ? 'Editor' : 'Viewer',

                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ----------------------------------------------------------
          // REMOVE
          // ----------------------------------------------------------
          IconButton(
            onPressed: onRemove,

            icon: Icon(
              Icons.close_rounded,
              size: 21.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
