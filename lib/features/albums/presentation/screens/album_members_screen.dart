import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app-colors.dart';

import '../bloc/album_members_cubit.dart';
import '../bloc/album_members_state.dart';

class AlbumMembersScreen extends StatelessWidget {
  const AlbumMembersScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  final String albumId;
  final String albumTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AlbumMembersCubit>()..getAlbumMembers(albumId),
      child: _AlbumMembersBody(albumTitle: albumTitle),
    );
  }
}

class _AlbumMembersBody extends StatelessWidget {
  const _AlbumMembersBody({required this.albumTitle});

  final String albumTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        leading: BackButton(),

        centerTitle: true,

        title: Text(
          'Members',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: BlocBuilder<AlbumMembersCubit, AlbumMembersState>(
        builder: (context, state) {
          if (state is AlbumMembersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumMembersFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          if (state is AlbumMembersLoaded) {
            if (state.members.isEmpty) {
              return Center(
                child: Text(
                  'No members found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
              itemCount: state.members.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final member = state.members[index];

                return _MemberCard(
                  name: member.fullName,
                  email: member.email,
                  role: member.role,
                  avatarPath: member.avatarPath,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.email,
    required this.role,
    required this.avatarPath,
  });

  final String name;
  final String? email;
  final String role;
  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          /// Avatar
          _buildAvatar(),

          SizedBox(width: 12.w),

          /// Name + Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                if (email != null && email!.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    email!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(width: 10.w),

          /// Role
          _RoleBadge(role: role),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatarPath == null || avatarPath!.trim().isEmpty) {
      return CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.surface,
        child: Icon(
          Icons.person_outline_rounded,
          color: AppColors.textSecondary,
          size: 25.sp,
        ),
      );
    }

    return CircleAvatar(
      radius: 24.r,
      backgroundColor: AppColors.surface,
      backgroundImage: NetworkImage(avatarPath!),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final normalizedRole = role.toLowerCase();

    String label;

    IconData icon;

    if (normalizedRole == 'owner') {
      label = 'Owner';
      icon = Icons.workspace_premium_outlined;
    } else if (normalizedRole == 'edit') {
      label = 'Edit';
      icon = Icons.edit_outlined;
    } else {
      label = 'View';
      icon = Icons.visibility_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
