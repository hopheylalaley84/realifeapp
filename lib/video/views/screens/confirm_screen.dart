import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/video/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key key,
    this.videoFile,
    this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            AspectRatio(aspectRatio: 2 / 3, child: VideoPlayer(controller)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Obx(() {
                return ElevatedButton(
                  onPressed: videoController.loadingVideo.value == true
                      ? null
                      : () => Get.back(),
                  child: videoController.loadingVideo.value == true
                      ? SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator())
                      : const CommonTextWidget(
                          text: 'Share',
                          size: 15,
                          fontWeight: FontWeight.w700,
                        ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
