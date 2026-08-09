import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/widgets/special_album_card.dart';

import '../../../../core/di/injection.dart';
import '../bloc/invited_album_cubit.dart';
import '../bloc/invited_album_state.dart';

class InvitedAlbumsScreen extends StatelessWidget {
  const InvitedAlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvitedAlbumsCubit>()..getInvitedAlbums(),
      child: const _InvitedAlbumsBody(),
    );
  }
}

class _InvitedAlbumsBody extends StatelessWidget {
  const _InvitedAlbumsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invited Albums"), centerTitle: true),
      body: BlocBuilder<InvitedAlbumsCubit, InvitedAlbumsState>(
        builder: (context, state) {
          if (state is InvitedAlbumsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InvitedAlbumsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is InvitedAlbumsLoaded) {
            if (state.albums.isEmpty) {
              return const Center(child: Text("No Invited Albums"));
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
