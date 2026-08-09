import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/widgets/special_album_card.dart';

import '../../../../core/di/injection.dart';
import '../bloc/albums_cubit.dart';
import '../bloc/albums_state.dart';
import '../bloc/invited_album_cubit.dart';
import '../bloc/invited_album_state.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AlbumsCubit>()..getMyAlbums()),
        BlocProvider(
          create: (_) => sl<InvitedAlbumsCubit>()..getInvitedAlbums(),
        ),
      ],
      child: const _AlbumsBody(),
    );
  }
}

class _AlbumsBody extends StatelessWidget {
  const _AlbumsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Albums",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          Text("My Albums", style: TextStyle(fontSize: 16.sp)),

          SizedBox(height: 16.h),

          BlocBuilder<AlbumsCubit, AlbumsState>(
            builder: (context, state) {
              if (state is AlbumsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AlbumsFailure) {
                return Text(state.message);
              }

              if (state is AlbumsLoaded) {
                if (state.albums.isEmpty) {
                  return const Text("No Albums Yet");
                }

                return Column(
                  children: state.albums.map((album) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: SpecialAlbumCard(
                        title: album.title,
                        updatedAt: album.updatedAt
                            .toLocal()
                            .toString()
                            .split(" ")
                            .first,
                        onTap: () {},
                      ),
                    );
                  }).toList(),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          //  SizedBox(height: 15.h),
          Text("Invited Albums", style: TextStyle(fontSize: 16.sp)),

          SizedBox(height: 16.h),

          BlocBuilder<InvitedAlbumsCubit, InvitedAlbumsState>(
            builder: (context, state) {
              if (state is InvitedAlbumsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is InvitedAlbumsFailure) {
                return Text(state.message);
              }

              if (state is InvitedAlbumsLoaded) {
                if (state.albums.isEmpty) {
                  return const Text("No Invited Albums");
                }

                return Column(
                  children: state.albums.map((album) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: SpecialAlbumCard(
                        title: album.title,
                        updatedAt: album.updatedAt
                            .toLocal()
                            .toString()
                            .split(" ")
                            .first,
                        onTap: () {},
                      ),
                    );
                  }).toList(),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
