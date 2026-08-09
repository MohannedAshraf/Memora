import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/widgets/special_album_card.dart';

import '../../../../core/di/injection.dart';
import '../bloc/albums_cubit.dart';
import '../bloc/albums_state.dart';

class MyAlbumsScreen extends StatelessWidget {
  const MyAlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AlbumsCubit>()..getMyAlbums(),
      child: const _MyAlbumsBody(),
    );
  }
}

class _MyAlbumsBody extends StatelessWidget {
  const _MyAlbumsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Albums"), centerTitle: true),
      body: BlocBuilder<AlbumsCubit, AlbumsState>(
        builder: (context, state) {
          if (state is AlbumsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is AlbumsLoaded) {
            if (state.albums.isEmpty) {
              return const Center(child: Text("No Albums Yet"));
            }

            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: state.albums.length,
              separatorBuilder: (_, _) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final album = state.albums[index];

                return SpecialAlbumCard(
                  title: album.title,
                  updatedAt: album.updatedAt
                      .toLocal()
                      .toString()
                      .split(" ")
                      .first,
                  onTap: () {},
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
