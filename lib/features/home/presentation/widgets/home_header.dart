import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:memora/features/notification/presentation/bloc/notification_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.onMenuTap,
  });

  final String userName;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Menu
        Container(
          height: 46.w,
          width: 46.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          ),
        ),

        SizedBox(width: 14.w),

        /// Welcome Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        /// Notification
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            int unreadCount = 0;

            if (state is NotificationLoaded) {
              unreadCount = state.unreadCount;
            }

            return InkWell(
              onTap: () {
                context.push('/notifications');
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 46.w,
                    width: 46.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  if (unreadCount > 0)
                    Positioned(
                      top: -5.h,
                      right: -5.w,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 20.w,
                          minHeight: 20.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: unreadCount > 99
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius: unreadCount > 99
                              ? BorderRadius.circular(10.r)
                              : null,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
