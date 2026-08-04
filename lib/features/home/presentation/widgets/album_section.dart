// ignore_for_file: unnecessary_underscores

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:memora/core/theme/app-colors.dart';

import 'album_card.dart';

class AlbumSection extends StatelessWidget {
  const AlbumSection({super.key, required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const Spacer(),

              TextButton(onPressed: onSeeAll, child: const Text("See All")),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        CarouselSlider.builder(
          itemCount: 5,

          itemBuilder: (_, index, __) {
            return AlbumCard(
              title: "Summer Trip",
              coverUrl: "",
              photosCount: 124,
              membersCount: 6,
              updatedAt: "Updated today",
              onTap: () {},
            );
          },

          options: CarouselOptions(
            height: 300.h,
            viewportFraction: 0.82,
            enlargeCenterPage: false,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,

            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,

            enableInfiniteScroll: true,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
