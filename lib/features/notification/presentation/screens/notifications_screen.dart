// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/features/notification/domain/entities/notification_entity.dart';

import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotificationsView();
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,

        leading: BackButton(),

        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is! NotificationLoaded) {
                return const SizedBox.shrink();
              }

              if (state.notifications.isEmpty) {
                return const SizedBox.shrink();
              }

              final hasUnread = state.notifications.any(
                (notification) => !notification.isRead,
              );

              if (!hasUnread) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: () {
                  context.read<NotificationCubit>().markAllAsRead();
                },
                child: Text(
                  'Mark all',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),

          SizedBox(width: 6.w),
        ],
      ),

      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const _NotificationsLoading();
          }

          if (state is NotificationFailure) {
            return _NotificationsError(
              message: state.message,
              onRetry: () {
                context.read<NotificationCubit>().getNotifications();
              },
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const _EmptyNotifications();
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () {
                return context.read<NotificationCubit>().getNotifications();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
                itemCount: state.notifications.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];

                  return _NotificationCard(
                    notification: notification,
                    onTap: () {
                      context.read<NotificationCubit>().markAsRead(
                        notification.id,
                      );
                    },
                    onDelete: () {
                      context.read<NotificationCubit>().deleteNotification(
                        notification.id,
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),

      direction: DismissDirection.endToStart,

      confirmDismiss: (_) async {
        return true;
      },

      onDismissed: (_) {
        onDelete();
      },

      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: 20.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.white,
          size: 24.sp,
        ),
      ),

      child: Material(
        color: isUnread ? AppColors.surface : AppColors.background,

        borderRadius: BorderRadius.circular(18.r),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),

          child: Container(
            padding: EdgeInsets.all(14.w),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isUnread
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.border,
              ),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NotificationIcon(type: notification.type, isUnread: isUnread),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          if (isUnread)
                            Container(
                              margin: EdgeInsets.only(left: 8.w, top: 5.h),
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),

                      if (notification.body != null &&
                          notification.body!.toString().isNotEmpty) ...[
                        SizedBox(height: 5.h),

                        Text(
                          notification.body!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],

                      SizedBox(height: 8.h),

                      Text(
                        _formatDate(notification.createdAt),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type, required this.isUnread});

  final String type;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (type) {
      case 'album_invitation':
      case 'invitation':
        icon = Icons.mail_outline_rounded;
        backgroundColor = AppColors.primary.withOpacity(0.10);
        iconColor = AppColors.primary;
        break;

      case 'photo_added':
        icon = Icons.photo_library_outlined;
        backgroundColor = AppColors.success.withOpacity(0.10);
        iconColor = AppColors.success;
        break;

      case 'album_updated':
        icon = Icons.photo_album_outlined;
        backgroundColor = AppColors.warning.withOpacity(0.10);
        iconColor = AppColors.warning;
        break;

      default:
        icon = Icons.notifications_none_rounded;
        backgroundColor = AppColors.surface;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(icon, size: 22.sp, color: iconColor),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 40.sp,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'No notifications yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'When something important happens, '
              'you will see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsLoading extends StatelessWidget {
  const _NotificationsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (_, _) {
        return Container(
          height: 95.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
          ),
        );
      },
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: AppColors.error,
            ),

            SizedBox(height: 14.h),

            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),

            SizedBox(height: 20.h),

            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
