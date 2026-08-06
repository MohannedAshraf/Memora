// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:memora/core/theme/app-colors.dart';
import 'package:memora/core/widgets/app_button.dart';
import 'package:memora/core/widgets/app_text_field.dart';

import '../../domain/entities/album_invitation_entity.dart';
import '../../domain/entities/member_role.dart';
import '../bloc/create_album_cubit.dart';
import '../bloc/create_album_state.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
 final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? coverImage;
  String? webImagePath;

  MemberRole selectedRole = MemberRole.viewer;

  final List<AlbumInvitationEntity> invitations = [];

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    if (kIsWeb) {
      setState(() {
        webImagePath = image.path;
      });
    } else {
      setState(() {
        coverImage = File(image.path);
      });
    }
  }

 void _addInvitation() {
    final email = _emailController.text.trim();

    if (email.isEmpty) return;

    final exists = invitations.any(
      (e) => e.email.toLowerCase() == email.toLowerCase(),
    );

    if (exists) return;

    setState(() {
      invitations.add(AlbumInvitationEntity(email: email, role: selectedRole));

      _emailController.clear();
      selectedRole = MemberRole.viewer;
    });
  }

  void _removeInvitation(AlbumInvitationEntity invitation) {
    setState(() {
      invitations.remove(invitation);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
   _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAlbumCubit, CreateAlbumState>(
      listener: (context, state) {
        if (state is CreateAlbumSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Album created successfully"),
            ),
          );

          _titleController.clear();
          _descriptionController.clear();
          _emailController.clear();

          setState(() {
            coverImage = null;
            webImagePath = null;
            invitations.clear();
            selectedRole = MemberRole.viewer;
          });
        }

        if (state is CreateAlbumFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
  child: SingleChildScrollView(
    padding: EdgeInsets.all(20.w),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //-----------------------------------------
          // Cover Image
          //-----------------------------------------

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 190.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: coverImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 46.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Choose Cover Image",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: kIsWeb
                          ? Image.network(
                              webImagePath!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              coverImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
          ),

          SizedBox(height: 28.h),

          //-----------------------------------------
          // Title
          //-----------------------------------------

          AppTextField(
            controller: _titleController,
            hintText: "Album Title",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Album title is required";
              }

              return null;
            },
          ),

          SizedBox(height: 18.h),

          //-----------------------------------------
          // Description
          //-----------------------------------------

          AppTextField(
            controller: _descriptionController,
            hintText: "Description",
            validator: (_) => null,
            maxLines: 3,
          ),

          SizedBox(height: 28.h),

          //-----------------------------------------
          // Username
          //-----------------------------------------

          AppTextField(
           controller: _emailController,
                    hintText: "Invite by Email",
                     keyboardType: TextInputType.emailAddress,
            validator: (_) => null,
          ),

          SizedBox(height: 22.h),

         Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Member Role",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6.h),

          RadioListTile<MemberRole>(
            value: MemberRole.viewer,
            groupValue: selectedRole,
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            title: const Text("Viewer"),
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
          ),

          RadioListTile<MemberRole>(
            value: MemberRole.editor,
            groupValue: selectedRole,
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            title: const Text("Editor"),
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
          ),
        ],
      ),
    ),

    SizedBox(width: 12.w),

    Padding(
      padding: EdgeInsets.only(top: 28.h),
      child: IconButton(
        onPressed: _addInvitation,
        icon: Icon(
          Icons.add_circle_rounded,
          color: AppColors.primary,
          size: 42.sp,
        ),
      ),
    ),
  ],
),
          if (invitations.isNotEmpty) ...[
            SizedBox(height: 12.h),

            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: invitations.map((invitation) {
                return Chip(
                  backgroundColor: AppColors.surface,
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeInvitation(invitation),
                  label: Text(
                    "${invitation.email} (${invitation.role.name})",
                  ),
                );
              }).toList(),
            ),
          ],

          SizedBox(height: 35.h),
                    AppButton(
                    text: "Create Album",
                    isLoading: state is CreateAlbumLoading,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      context.read<CreateAlbumCubit>().createAlbum(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        coverImage: coverImage,
                        invitations: invitations,
                      );
                    },
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
