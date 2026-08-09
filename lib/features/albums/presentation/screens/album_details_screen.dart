// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/services/media_picker_service.dart';
import 'package:memora/features/albums/domain/entities/album_media_entity.dart';
import 'package:memora/features/albums/presentation/bloc/album_user_role_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app-colors.dart';

import '../bloc/album_details_cubit.dart';
import '../bloc/album_details_state.dart';
import '../bloc/album_members_cubit.dart';
import '../bloc/album_members_state.dart';
import '../bloc/album_media_cubit.dart';
import '../bloc/album_media_state.dart';

class AlbumDetailsScreen extends StatelessWidget {
  const AlbumDetailsScreen({super.key, required this.albumId});

  final String albumId;

  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AlbumDetailsCubit>()..getAlbumDetails(albumId),
        ),

        BlocProvider(
          create: (_) => sl<AlbumMembersCubit>()..getAlbumMembers(albumId),
        ),

        BlocProvider(
          create: (_) => sl<AlbumMediaCubit>()..getAlbumMedia(albumId),
        ),

        BlocProvider(
          create: (_) => sl<AlbumUserRoleCubit>()..getUserRole(albumId),
        ),
      ],
      child: _AlbumDetailsBody(albumId: albumId),
    );
  }
}

class _AlbumDetailsBody extends StatelessWidget {
  const _AlbumDetailsBody({required this.albumId});

  final String albumId;
  Future<void> _handleAddMedia(BuildContext context, String albumId) async {
    final role = context.read<AlbumUserRoleCubit>().state;

    /// =========================
    /// User role not loaded yet
    /// =========================
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait, checking your permissions...'),
        ),
      );

      return;
    }

    /// =========================
    /// Viewer
    /// =========================
    if (role.toLowerCase() == 'view') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot add photos or videos to this album.'),
        ),
      );

      return;
    }

    /// =========================
    /// Editor / Owner
    /// =========================
    if (role.toLowerCase() == 'edit' || role.toLowerCase() == 'owner') {
      await _pickMedia(context);
    }
  }
  Future<void> _pickMedia(BuildContext context) async {
    try {
      final mediaPicker = sl<MediaPickerService>();

      final files = await mediaPicker.pickMultipleMedia();

      /// User cancelled picker
      if (files.isEmpty) {
        return;
      }

      /// =========================
      /// Maximum 30
      /// =========================
      if (files.length > 30) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can select a maximum of 30 photos or videos at a time.',
            ),
          ),
        );

        return;
      }

      /// =========================
      /// Selected successfully
      /// =========================

      debugPrint('Selected media: ${files.length}');

      for (final file in files) {
        debugPrint('Selected: ${file.name}');
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${files.length} media selected')));

      /// هنا المرحلة القادمة:
      ///
      /// Upload files to Supabase Storage
      /// +
      /// Insert records into album_photos
      /// +
      /// refresh AlbumMediaCubit
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to select media: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,

        leading: BackButton(),

        title: BlocBuilder<AlbumDetailsCubit, AlbumDetailsState>(
          builder: (context, state) {
            if (state is AlbumDetailsLoaded) {
              return Text(
                state.album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
              );
            }

            return Text(
              'Album',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
            );
          },
        ),

        actions: [
          IconButton(
            tooltip: 'Members',
            onPressed: () {
              final state = context.read<AlbumDetailsCubit>().state;

              if (state is AlbumDetailsLoaded) {
                context.push(
                  '/album-details/$albumId/members',
                  extra: state.album.title,
                );
              }
            },
            icon: Icon(Icons.people_outline_rounded, size: 25.sp),
          ),

          SizedBox(width: 6.w),
        ],
      ),

      body: BlocBuilder<AlbumDetailsCubit, AlbumDetailsState>(
        builder: (context, state) {
          if (state is AlbumDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumDetailsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is AlbumDetailsLoaded) {
            return _AlbumDetailsContent(albumId: albumId, album: state.album);
          }

          return const SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        
          // هنضيف هنا:
          // 1. نجيب role المستخدم
          // 2. لو viewer نعرض رسالة
          // 3. لو editor/owner نفتح Media Picker
          // 4. max 30 assets
           onPressed: () => _handleAddMedia(context, albumId),
      
        child: const Icon(Icons.add),
     ), );
  }
}

class _AlbumDetailsContent extends StatelessWidget {
  const _AlbumDetailsContent({required this.albumId, required this.album});

  final String albumId;
  final dynamic album;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<AlbumDetailsCubit>().getAlbumDetails(albumId),
          context.read<AlbumMembersCubit>().getAlbumMembers(albumId),
          context.read<AlbumMediaCubit>().getAlbumMedia(albumId),
        ]);
      },

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =========================
            /// Cover
            /// =========================
            _buildCover(context, album.coverPhotoId),

            SizedBox(height: 20.h),

            /// =========================
            /// Album Title
            /// =========================
            Text(
              album.title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            /// =========================
            /// Description
            /// =========================
            if (album.description.trim().isNotEmpty) ...[
              Text(
                album.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 18.h),
            ],

            /// =========================
            /// Album Information
            /// =========================
            _buildAlbumInfo(context, album),

            SizedBox(height: 28.h),

            /// =========================
            /// Media Title
            /// =========================
            Text(
              'Memories',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 14.h),

            /// =========================
            /// Media Grid
            /// =========================
            const _AlbumMediaGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context, String? coverPhotoId) {
    if (coverPhotoId == null || coverPhotoId.isEmpty) {
      return _noCover();
    }

    return FutureBuilder<String>(
      future: _getCoverUrl(coverPhotoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: 220.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _noCover();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.network(
            snapshot.data!,
            width: double.infinity,
            height: 220.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return _noCover();
            },
          ),
        );
      },
    );
  }

  Future<String> _getCoverUrl(String coverPhotoId) async {
    final client = Supabase.instance.client;

    final photo = await client
        .from('album_photos')
        .select('storage_path')
        .eq('id', coverPhotoId)
        .maybeSingle();

    if (photo == null) {
      return '';
    }

    final storagePath = photo['storage_path'] as String?;

    if (storagePath == null || storagePath.isEmpty) {
      return '';
    }

    return client.storage.from('album-photos').getPublicUrl(storagePath);
  }

  Widget _noCover() {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 55.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 8.h),
          Text(
            'No Cover',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumInfo(BuildContext context, dynamic album) {
    return BlocBuilder<AlbumMembersCubit, AlbumMembersState>(
      builder: (context, state) {
        int membersCount = 0;

        if (state is AlbumMembersLoaded) {
          membersCount = state.members.length;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Created',
                      value: _formatDate(album.createdAt),
                    ),
                  ),

                  Container(width: 1, height: 40.h, color: AppColors.border),

                  Expanded(
                    child: _InfoItem(
                      icon: Icons.people_outline_rounded,
                      title: 'Members',
                      value: membersCount.toString(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.update_rounded,
                      title: 'Updated',
                      value: _formatDate(album.updatedAt),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }
}
class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 19.sp, color: AppColors.primary),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _AlbumMediaGrid extends StatelessWidget {
  const _AlbumMediaGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumMediaCubit, AlbumMediaState>(
      builder: (context, state) {
        if (state is AlbumMediaLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AlbumMediaFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(state.message, textAlign: TextAlign.center),
            ),
          );
        }

        if (state is AlbumMediaLoaded) {
          if (state.media.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 50.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No memories yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.media.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.w,
              mainAxisSpacing: 5.h,
              childAspectRatio: 1,
            ),

            itemBuilder: (context, index) {
              final media = state.media[index];

              return _MediaGridItem(
                media: media,
                onTap: () {
                  // هنفتح هنا Full Screen Image / Video
                  // في الخطوة القادمة.
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
class _MediaGridItem extends StatelessWidget {
  const _MediaGridItem({required this.media, required this.onTap});

  final AlbumMediaEntity media;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              media.url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: AppColors.surface,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textSecondary,
                    size: 28.sp,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),

            /// Video indicator
            if (media.isVideo)
              Positioned(
                right: 7.w,
                bottom: 7.h,
                child: Container(
                  width: 27.w,
                  height: 27.w,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
