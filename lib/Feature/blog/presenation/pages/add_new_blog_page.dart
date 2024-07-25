import 'dart:io';

import 'package:blog/Feature/blog/presenation/bloc/blog_bloc.dart';
import 'package:blog/Feature/blog/presenation/pages/blog_page.dart';
import 'package:blog/Feature/blog/presenation/widgets/blog_editer.dart';
import 'package:blog/core/comman/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/comman/widgets/loader.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/pick_image.dart';
import 'package:blog/core/utils/show_snakbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  List<String> selectedTopic = [];
  File? image;

  void selectImage() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  void uploadBlog() {
    if (formkey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
                posterId: posterId,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                image: image!,
                topics: selectedTopic),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
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
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnakBar(context, state.error);
          } else if (state is BlogsUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context, 
              BlogPage.route(), 
              (route)=> false,
            );
          }
        },
        builder: (context, state) {
          if(state is BlogLoading){
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your Image',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment',
                        ]
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopic.contains(e)) {
                                      selectedTopic.remove(e);
                                    } else {
                                      selectedTopic.add(e);
                                    }
                                    selectedTopic.add(e);
                                    setState(() {});
                                  },
                                  child: Chip(
                                    color: selectedTopic.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1)
                                        : null,
                                    label: Text(e),
                                    side: selectedTopic.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditer(
                        controller: titleController, hintText: "Blog Title"),
                    const SizedBox(height: 10),
                    BlogEditer(
                        controller: contentController, hintText: "Blog Content")
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
