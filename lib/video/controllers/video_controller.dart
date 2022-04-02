import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/controllers/vid_controller.dart';
import 'package:realifeapp/video/models/post_model.dart';
import 'package:realifeapp/video/views/screens/confirm_screen.dart';
import 'package:video_compress/video_compress.dart';

class VideoController extends GetxController {
  VidController vidController = Get.put(VidController());

  RxBool loadingVideo = RxBool(false);

  RxSet tagList = RxSet({});
  RxSet dropMenuList = RxSet({
    'Category1',
    'Category2',
    'Category3',
  });
  RxSet tagListBase = RxSet({'tag1', 'tag2', 'tag3', 'tag4'});
  RxString categorySelect = RxString('');

  RxBool addPostLoading = RxBool(false);
  RxString descriptionPost = RxString('');

  Rx<File> videoFile = Rx<File>(null);
  RxString videoPath = RxString('');

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      videoFile.value = File(video.path);
      videoPath.value = video.path;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          );
        }),
      );
    }
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  String thumbnailPath;

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath,quality: 30);
    thumbnailPath = thumbnail.path;
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }



  List<String> searchNameForFirebase(name){

    List<String> splitList = name.split(' ');
    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    return indexList;
  }
  // upload video
  uploadVideo(String videoPath1) async {
    try {
      loadingVideo.value = true;
      int num1 = Random().nextInt(100000000);
      int num2 = Random().nextInt(100000000);

      String uid = authInstance.currentUser.uid;
      String videoUrl =
          await _uploadVideoToStorage(num1.toString(), videoPath1);
      String thumbnail =
          await _uploadImageToStorage(num2.toString(), videoPath1);
      DocumentReference ref = firestore.collection('posts').doc();

      ref.set({
        'id': ref.id,
        'type': 'video',
        'createDate': Timestamp.now(),
        'ownerId': uid,
        'text': descriptionPost.value,
        'videoUrl': videoUrl,
        'thumbnail': thumbnail,
        'tags': tagList.toList(),
        'category': categorySelect.value,
        'active': true,
        'songName': '',
        'fake': false,
        'thumbnailPath' : thumbnailPath,
        'searchName' : searchNameForFirebase(vidController.userName.value),
      }).whenComplete(() {
        loadingVideo.value = false;
      });
      videoFile.value = null;
      videoPath.value = '';
      tagList.clear();
      descriptionPost.value = '';
      vidController.getPosts();
      Get.back();
      Get.back();
    } catch (e) {
      loadingVideo.value = false;
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
