// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:memora/core/di/injection.dart';
import 'package:memora/core/theme/app-colors.dart';

import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/utils/image_picker_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getProfile(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileFailure) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () {
                    context.read<ProfileCubit>().getProfile();
                  },
                );
              }

              if (state is ProfileLoaded) {
                return _ProfileContent(profile: state.profile);
              }

              if (state is ProfileUpdating) {
                return _ProfileContent(
                  profile: state.profile,
                  isUpdating: true,
                );
              }

              if (state is ProfileUpdated) {
                return _ProfileContent(profile: state.profile);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE CONTENT
// ============================================================

class _ProfileContent extends StatelessWidget {
  final dynamic profile;
  final bool isUpdating;

  const _ProfileContent({required this.profile, this.isUpdating = false});

  Future<void> _changeAvatar(BuildContext context) async {
    if (isUpdating) {
      return;
    }

    final image = await ImagePickerHelper.pickImage();

    if (image == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    await context.read<ProfileCubit>().changeAvatar(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    String? avatarUrl;

    if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
      avatarUrl = supabase.storage
          .from('album-photos')
          .getPublicUrl(profile.avatarPath!);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ======================================================
        // APP BAR
        // ======================================================
        SliverAppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          pinned: true,
          centerTitle: true,
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // ======================================================
        // BODY
        // ======================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ==================================================
              // PROFILE HEADER
              // ==================================================
              _ProfileHeader(
                avatarUrl: avatarUrl,
                fullName: profile.fullName,
                email: profile.email,
                onAvatarTap: isUpdating ? null : () => _changeAvatar(context),
              ),

              SizedBox(height: 15.h),

              // ==================================================
              // PROFILE INFO CARD
              // ==================================================
              _InfoCard(fullName: profile.fullName, email: profile.email),

              SizedBox(height: 10.h),

              // ==================================================
              // ACTIONS TITLE
              // ==================================================
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // ==================================================
              // EDIT PROFILE
              // ==================================================
              _ProfileActionTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Change your name or profile picture',
                onTap: isUpdating
                    ? null
                    : () {
                        context.push('/edit-profile', extra: profile);
                      },
              ),

              SizedBox(height: 10.h),

              // ==================================================
              // SETTINGS
              // ==================================================
              _ProfileActionTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Manage your app preferences',
                onTap: () {
                  // Settings later
                },
              ),

              SizedBox(height: 10.h),

              // ==================================================
              // LOGOUT
              // ==================================================
              _ProfileActionTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                isDanger: true,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await Supabase.instance.client.auth.signOut();

                if (!context.mounted) return;

                context.pushReplacement('/login');
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// PROFILE HEADER
// ============================================================

class _ProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String fullName;
  final String email;
  final VoidCallback? onAvatarTap;

  const _ProfileHeader({
    required this.avatarUrl,
    required this.fullName,
    required this.email,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ======================================================
        // AVATAR
        // ======================================================
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 58.r,
                backgroundColor: AppColors.surface,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Icon(
                        Icons.person_outline_rounded,
                        size: 55.sp,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),

            // ==================================================
            // EDIT AVATAR ICON
            // ==================================================
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAvatarTap,
                borderRadius: BorderRadius.circular(18.r),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 18.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // ======================================================
        // NAME
        // ======================================================
        Text(
          fullName.isEmpty ? 'No Name' : fullName,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 6.h),

        // ======================================================
        // EMAIL
        // ======================================================
        Text(
          email,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ============================================================
// INFO CARD
// ============================================================

class _InfoCard extends StatelessWidget {
  final String fullName;
  final String email;

  const _InfoCard({required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            title: 'Full Name',
            value: fullName.isEmpty ? 'Not set' : fullName,
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(height: 1, color: AppColors.border),
          ),

          _InfoRow(icon: Icons.email_outlined, title: 'Email', value: email),
        ],
      ),
    );
  }
}

// ============================================================
// INFO ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 21.sp, color: AppColors.textSecondary),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ACTION TILE
// ============================================================

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDanger;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDanger ? Colors.red : AppColors.textPrimary;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDanger ? Colors.red.withOpacity(0.15) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              // ==================================================
              // ICON
              // ==================================================
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isDanger
                      ? Colors.red.withOpacity(0.08)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(icon, size: 21.sp, color: iconColor),
              ),

              SizedBox(width: 13.w),

              // ==================================================
              // TEXT
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // ARROW
              // ==================================================
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36.sp,
                color: Colors.red,
              ),
            ),

            SizedBox(height: 18.h),

            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),

            SizedBox(height: 20.h),

            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
