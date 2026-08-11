import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:memora/core/theme/app-colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _fullName = 'User';
  String? _avatarUrl;

  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD USER DATA
  // ============================================================

  Future<void> _loadProfile() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        _isLoadingProfile = false;
      });

      return;
    }

    try {
      // ========================================================
      // FULL NAME
      // ========================================================

      final metadata = user.userMetadata;

      final fullName = metadata?['full_name'];

      // ========================================================
      // AVATAR
      // ========================================================

      final avatarPath = metadata?['avatar_url'];

      String? avatarUrl;

      if (avatarPath != null && avatarPath is String && avatarPath.isNotEmpty) {
        avatarUrl = _supabase.storage
            .from('album-photos')
            .getPublicUrl(avatarPath);
      }

      if (!mounted) return;

      setState(() {
        _fullName = fullName is String && fullName.trim().isNotEmpty
            ? fullName.trim()
            : 'User';

        _avatarUrl = avatarUrl;

        _isLoadingProfile = false;
      });
    } catch (e) {
      debugPrint('AppDrawer user data error: $e');

      if (!mounted) return;

      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _goTo(String route) {
    Navigator.of(context).pop();

    Future.microtask(() {
      if (!mounted) return;

      context.push(route);
    });
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    Navigator.of(context).pop();

    await _supabase.auth.signOut();

    if (!mounted) return;

    context.go('/login');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // ======================================================
          // HEADER
          // ======================================================
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.only(
              top: 60.h,
              bottom: 32.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              children: [
                // ==================================================
                // AVATAR
                // ==================================================
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: CircleAvatar(
                    radius: 43.r,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _avatarUrl != null
                        ? NetworkImage(_avatarUrl!)
                        : null,
                    child: _avatarUrl == null
                        ? Icon(
                            Icons.person_outline_rounded,
                            size: 45.sp,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),

                SizedBox(height: 16.h),

                // ==================================================
                // FULL NAME
                // ==================================================
                _isLoadingProfile
                    ? SizedBox(
                        width: 100.w,
                        height: 20.h,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Text(
                        _fullName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ],
            ),
          ),

          SizedBox(height: 18.h),

          // ======================================================
          // MENU
          // ======================================================
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              children: [
                // ==================================================
                // SETTINGS
                // ==================================================
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _goTo('/settings'),
                ),

                SizedBox(height: 15.h),

                // ==================================================
                // NOTIFICATIONS
                // ==================================================
                _buildDrawerItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () => _goTo('/notifications'),
                ),

                SizedBox(height: 15.h),

                // ==================================================
                // DIVIDER
                // ==================================================
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: const Divider(color: AppColors.divider, height: 1),
                ),

                // ==================================================
                // ABOUT
                // ==================================================
                _buildDrawerItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () {
                    // هنضيف route بعدين
                  },
                ),

                SizedBox(height: 15.h),

                // ==================================================
                // HELP & SUPPORT
                // ==================================================
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    // هنضيف route بعدين
                  },
                ),

                SizedBox(height: 15.h),

                // ==================================================
                // LOGOUT
                // ==================================================
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER ITEM
  // ============================================================

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      leading: Icon(
        icon,
        size: 23.sp,
        color: iconColor ?? AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: title == 'Logout'
          ? null
          : Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: AppColors.textHint,
            ),
    );
  }
}
