// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.albumTitle,
    required this.email,
    required this.createdAt,
    required this.onAccept,
    required this.onDecline,
  });

  final String albumTitle;
  final String email;
  final DateTime createdAt;

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      "dd MMM yyyy • hh:mm a",
    ).format(createdAt.toLocal());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  albumTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  date,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          InkWell(
            onTap: onAccept,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green),
            ),
          ),

          SizedBox(width: 10.w),

          InkWell(
            onTap: onDecline,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
