// ignore_for_file: unnecessary_underscores

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:memora/core/theme/app-colors.dart';

import 'package:memora/features/albums/presentation/bloc/albums_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/albums_state.dart';

import 'package:memora/features/albums/presentation/bloc/invited_album_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/invited_album_state.dart';

import 'album_card.dart';

enum AlbumSectionType { myAlbums, invitedAlbums }

class AlbumSection extends StatelessWidget {
  const AlbumSection({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.type,
  });

  final String title;
  final VoidCallback onSeeAll;
  final AlbumSectionType type;

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

        if (type == AlbumSectionType.myAlbums)
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
                      updatedAt: album.updatedAt
                          .toLocal()
                          .toString()
                          .split(" ")
                          .first,
                      onTap: () {
                         context.push('/album-details/${album.id}');
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: 300.h,
                    viewportFraction: 0.82,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    enableInfiniteScroll: true,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          )
        else
          BlocBuilder<InvitedAlbumsCubit, InvitedAlbumsState>(
            builder: (context, state) {
              if (state is InvitedAlbumsLoading) {
                return SizedBox(
                  height: 300.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state is InvitedAlbumsFailure) {
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

              if (state is InvitedAlbumsLoaded) {
                if (state.albums.isEmpty) {
                  return SizedBox(
                    height: 300.h,
                    child: const Center(child: Text("No Invited Albums")),
                  );
                }

                return CarouselSlider.builder(
                  itemCount: state.albums.length,
                  itemBuilder: (_, index, __) {
                    final album = state.albums[index];

                    return AlbumCard(
                      title: album.title,
                      updatedAt: album.updatedAt
                          .toLocal()
                          .toString()
                          .split(" ")
                          .first,
                      onTap: () {
                         context.push('/album-details/${album.id}');
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: 300.h,
                    viewportFraction: 0.82,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    enableInfiniteScroll: true,
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
