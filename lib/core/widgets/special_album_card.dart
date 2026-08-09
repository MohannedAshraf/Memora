import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';

class SpecialAlbumCard extends StatelessWidget {
  const SpecialAlbumCard({
    super.key,
    required this.title,
    required this.updatedAt,
    this.onTap,
  });

  final String title;
  final String updatedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 145.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// =========================
            /// Cover
            /// =========================
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                width: 120.w,
                height: double.infinity,
                child: Container(
                  color: AppColors.surface,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 38.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "No Cover",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 14.w),

            /// =========================
            /// Album Information
            /// =========================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// Privacy
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 15.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Private Album",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// Updated At
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 15.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          updatedAt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// =========================
            /// Arrow
            /// =========================
            SizedBox(width: 5.w),

            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
