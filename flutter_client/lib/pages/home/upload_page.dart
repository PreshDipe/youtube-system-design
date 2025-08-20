import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/cubits/upload_video/upload_video_cubit.dart';
import 'package:flutter_client/utils/utils.dart';

class UploadPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => UploadPage());
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  String visibility = 'PRIVATE';
  File? imageFile;
  File? videoFile;

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final _imageFile = await pickImage();

    setState(() {
      imageFile = _imageFile;
    });
  }

  void selectVideo() async {
    final _videoFile = await pickVideo();

    setState(() {
      videoFile = _videoFile;
    });
  }

  void uploadVideo() async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        videoFile != null &&
        imageFile != null) {
      await context.read<UploadVideoCubit>().uploadVideo(
        videoFile: videoFile!,
        thumbnailFile: imageFile!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        visibility: visibility,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Page')),
      body: BlocConsumer<UploadVideoCubit, UploadVideoState>(
        listener: (context, state) {
          if (state is UploadVideoSuccess) {
            showSnackBar('Video uploaded successfully!', context);
            Navigator.pop(context);
          } else if (state is UploadVideoError) {
            showSnackBar(state.error, context);
          }
        },
        builder: (context, state) {
          if (state is UploadVideoLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: selectImage,
                    child:
                        imageFile != null
                            ? SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Image.file(imageFile!, fit: BoxFit.cover),
                            )
                            : DottedBorder(
                              dashPattern: [10, 4],
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              radius: Radius.circular(10),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    Text(
                                      'Select the thumbnail for your video',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: selectVideo,
                    child:
                        videoFile != null
                            ? Text(videoFile!.path)
                            : DottedBorder(
                              dashPattern: [10, 4],
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              radius: Radius.circular(10),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.video_file_outlined, size: 40),
                                    Text(
                                      'Select your video file',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(hintText: 'Description'),
                    maxLines: null,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton(
                      value: visibility,
                      padding: EdgeInsets.all(15),
                      underline: SizedBox(),
                      items:
                          ['PUBLIC', 'PRIVATE', 'UNLISTED']
                              .map(
                                (elem) => DropdownMenuItem(
                                  value: elem,
                                  child: Text(elem),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          visibility = val!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: uploadVideo,
                    child: Text(
                      'UPLOAD',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
