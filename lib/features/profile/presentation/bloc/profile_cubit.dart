import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../../domain/usecases/upload_avatar_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
  }) : super(ProfileInitial());

  // ============================================================
  // GET PROFILE
  // ============================================================

  Future<void> getProfile() async {
    emit(ProfileLoading());

    try {
      final profile = await getProfileUseCase();

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> updateProfile({
    required String fullName,
    String? avatarPath,
  }) async {
    final currentState = state;

    ProfileEntity? currentProfile;

    if (currentState is ProfileLoaded) {
      currentProfile = currentState.profile;
    } else if (currentState is ProfileUpdated) {
      currentProfile = currentState.profile;
    }

    if (currentProfile != null) {
      emit(ProfileUpdating(currentProfile));
    }

    try {
      final profile = await updateProfileUseCase(
        fullName: fullName,
        avatarPath: avatarPath,
      );

      emit(ProfileUpdated(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // ============================================================
  // UPLOAD AVATAR
  // ============================================================

  Future<String?> uploadAvatar(String filePath) async {
    try {
      final path = await uploadAvatarUseCase(filePath);

      return path;
    } catch (e) {
      emit(ProfileFailure(e.toString()));
      return null;
    }
  }

  // ============================================================
  // CHANGE AVATAR
  // ============================================================

  Future<void> changeAvatar(String filePath) async {
    final currentState = state;

    ProfileEntity? currentProfile;

    if (currentState is ProfileLoaded) {
      currentProfile = currentState.profile;
    } else if (currentState is ProfileUpdated) {
      currentProfile = currentState.profile;
    }

    if (currentProfile == null) {
      return;
    }

    emit(ProfileUpdating(currentProfile));

    try {
      // 1. Upload image
      final avatarPath = await uploadAvatarUseCase(filePath);

      // 2. Update profile with new avatar path
      final updatedProfile = await updateProfileUseCase(
        fullName: currentProfile.fullName,
        avatarPath: avatarPath,
      );

      // 3. Emit updated profile
      emit(ProfileUpdated(updatedProfile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
