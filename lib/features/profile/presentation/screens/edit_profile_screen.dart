import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/core/utils/image_picker_helper.dart';

import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final dynamic profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickImage();

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _save() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));

      return;
    }

    final cubit = context.read<ProfileCubit>();

    String? avatarPath;

    // Upload new avatar if user selected one
    if (_selectedImage != null) {
      avatarPath = await cubit.uploadAvatar(_selectedImage!.path);

      if (avatarPath == null) {
        return;
      }
    }

    await cubit.updateProfile(fullName: name, avatarPath: avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    String? avatarUrl;

    if (widget.profile.avatarPath != null &&
        widget.profile.avatarPath!.isNotEmpty) {
      avatarUrl = supabase.storage
          .from('album-photos')
          .getPublicUrl(widget.profile.avatarPath!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            context.pop();
          }

          if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.w),

          child: Column(
            children: [
              SizedBox(height: 10.h),

              // ==================================================
              // AVATAR
              // ==================================================
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppColors.surface,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: _selectedImage == null && avatarUrl == null
                          ? Icon(
                              Icons.person_outline_rounded,
                              size: 55.sp,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                  ),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 19.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Text(
                'Tap the camera to change your photo',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 35.h),

              // ==================================================
              // FULL NAME
              // ==================================================
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // EMAIL
              // ==================================================
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              TextField(
                readOnly: true,
                controller: TextEditingController(text: widget.profile.email),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 35.h),

              // ==================================================
              // SAVE BUTTON
              // ==================================================
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading = state is ProfileUpdating;

                  return SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
