import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../bloc/create_album_cubit.dart';
import '../bloc/create_album_state.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> invitedEmails = [];
  String? webImagePath;

  File? coverImage;

  final ImagePicker _picker = ImagePicker();

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

  void _addEmail() {
    final email = _emailController.text.trim();

    if (email.isEmpty) return;

    if (invitedEmails.contains(email)) return;

    setState(() {
      invitedEmails.add(email);
      _emailController.clear();
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
              content: Text("Album Created Successfully"),
            ),
          );

          _titleController.clear();
          _descriptionController.clear();
          _emailController.clear();

          setState(() {
            coverImage = null;
            invitedEmails.clear();
          });
        }

        if (state is CreateAlbumFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade100,
                      ),
                      child: coverImage == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 45,
                                ),
                                SizedBox(height: 10),
                                Text("Choose Cover Image"),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: kIsWeb
                                  ? Image.network(
                                      coverImage!.path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(coverImage!, fit: BoxFit.cover),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  AppTextField(
                    controller: _titleController,
                    hintText: "Album Title",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title is required";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _descriptionController,
                    hintText: "Description",
                    validator: (_) => null,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      Expanded(
                        child: AppTextField(
                          controller: _emailController,
                          hintText: "Invite by Email",
                          validator: (_) => null,
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton(
                        onPressed: _addEmail,
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  if (invitedEmails.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: invitedEmails.map((email) {
                        return Chip(
                          label: Text(email),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              invitedEmails.remove(email);
                            });
                          },
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 30),
                                    AppButton(
                    text: "Create Album",
                    isLoading: state is CreateAlbumLoading,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      context.read<CreateAlbumCubit>().createAlbum(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        coverImage: coverImage,
                        invitedEmails: invitedEmails,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
