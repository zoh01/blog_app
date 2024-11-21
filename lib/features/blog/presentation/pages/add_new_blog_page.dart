import 'dart:io';

import 'package:blog_app/constants/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/constants/common/widgets/loader.dart';
import 'package:blog_app/constants/konstants/konstants.dart';
import 'package:blog_app/constants/utils/pick_image.dart';
import 'package:blog_app/constants/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog () {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn)
              .user
              .id;
      context.read<BlogBloc>().add(BlogUpload(
        posterId: posterId,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        image: image!,
        topics: selectedTopics,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
  listener: (context, state) {
    if(state is BlogFailure) {
      showSnackBar(context, state.error);
    } else if(state is BlogUploadSuccess) {
      Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route) => false);
    }
  },
  builder: (context, state) {
    if (state is BlogLoading) {
      return const ZLoader();
    }
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: DottedBorder(
                          color: Colors.grey.shade600,
                          dashPattern: const [10, 5],
                          radius: const Radius.circular(12),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 36),
                                SizedBox(height: 10),
                                Text('Select your image',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Konstants.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedTopics.contains(e)) {
                                  selectedTopics.remove(e);
                                } else {
                                  selectedTopics.add(e);
                                }
                                setState(() {});
                              },
                              child: Chip(
                                label: Text(e),
                                color: selectedTopics.contains(e)
                                    ? const MaterialStatePropertyAll(
                                        Colors.blueGrey)
                                    : null,
                                side: selectedTopics.contains(e)
                                    ? null
                                    : const BorderSide(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlogEditor(
                  controller: titleController,
                  labelText: 'Blog Title',
                ),
                const SizedBox(
                  height: 20,
                ),
                BlogEditor(
                    controller: contentController, labelText: 'Blog Content')
              ],
            ),
          ),
        ),
      );
  },
),
    );
  }
}
