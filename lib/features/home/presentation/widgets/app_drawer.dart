import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/app-colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// ================= Header =================
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.only(top: 60.h, bottom: 28.h),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42.r,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 45.sp,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Mohanned Ashraf',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          /// ================= Items =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Us'),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help'),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    context.pushReplacement('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
