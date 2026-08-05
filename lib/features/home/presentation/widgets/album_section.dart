// ignore_for_file: unnecessary_underscores

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/features/albums/presentation/bloc/albums_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/albums_state.dart';

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

        BlocBuilder<AlbumsCubit, AlbumsState>(
          builder: (context, state) {
            if (state is AlbumsLoading) {
              return SizedBox(
                height: 300.h,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AlbumsFailure) {
              return SizedBox(
                height: 300.h,
                child: Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            if (state is AlbumsLoaded) {
              if (state.albums.isEmpty) {
                return SizedBox(
                  height: 300.h,
                  child: const Center(child: Text("No Albums Yet")),
                );
              }

              return CarouselSlider.builder(
                itemCount: state.albums.length,
                itemBuilder: (_, index, __) {
                  final album = state.albums[index];

                  return AlbumCard(
                    title: album.title,
                    // coverUrl: "",
                    // photosCount: 0,
                    // membersCount: 0,
                    updatedAt: album.updatedAt
                        .toLocal()
                        .toString()
                        .split(" ")
                        .first,
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
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
