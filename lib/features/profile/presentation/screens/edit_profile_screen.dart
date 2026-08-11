// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/core/utils/image_picker_helper.dart';
import 'package:memora/core/widgets/app_button.dart';
import 'package:memora/core/widgets/app_text_field.dart';

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
  late final TextEditingController _emailController;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.fullName);

    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickImage();

    if (image == null) return;

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

    // Upload new avatar if selected
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

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,

        leading: BackButton(),

        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
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

          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // PROFILE IMAGE
              // ====================================================
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Avatar container
                        Container(
                          width: 132.w,
                          height: 132.w,
                          padding: EdgeInsets.all(4.w),

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),

                          child: ClipOval(
                            child: Container(
                              color: AppColors.surface,

                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : avatarUrl != null
                                  ? Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,

                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person_outline_rounded,
                                              size: 58.sp,
                                              color: AppColors.textSecondary,
                                            );
                                          },
                                    )
                                  : Icon(
                                      Icons.person_outline_rounded,
                                      size: 58.sp,
                                      color: AppColors.textSecondary,
                                    ),
                            ),
                          ),
                        ),

                        // Camera button
                        Material(
                          color: Colors.transparent,

                          child: InkWell(
                            onTap: _pickImage,

                            borderRadius: BorderRadius.circular(20.r),

                            child: Container(
                              width: 42.w,
                              height: 42.w,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 19.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    Text(
                      'Change profile photo',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      'Choose a photo from your gallery',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 35.h),

              // ====================================================
              // PERSONAL INFORMATION
              // ====================================================
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                'Update your profile information below.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 20.h),

              // ====================================================
              // FULL NAME
              // ====================================================
              Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 8.h),

              AppTextField(
                controller: _nameController,
                hintText: 'Enter your full name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }

                  return null;
                },
                keyboardType: TextInputType.name,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 21.sp,
                ),
              ),

              SizedBox(height: 20.h),

              // ====================================================
              // EMAIL
              // ====================================================
              Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 8.h),

              Opacity(
                opacity: 0.75,
                child: AppTextField(
                  controller: _emailController,
                  hintText: 'Email address',
                  validator: null,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textSecondary,
                    size: 21.sp,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),

                  SizedBox(width: 5.w),

                  Expanded(
                    child: Text(
                      'Email address cannot be changed here.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35.h),

              // ====================================================
              // SAVE BUTTON
              // ====================================================
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading = state is ProfileUpdating;

                  return AppButton(
                    text: 'Save Changes',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _save,
                  );
                },
              ),

              SizedBox(height: 12.h),

              // ====================================================
              // CANCEL BUTTON
              // ====================================================
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
