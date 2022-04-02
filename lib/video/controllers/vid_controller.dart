import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/auth/controllers/auth_controller.dart';
import 'package:realifeapp/video/models/comment_model.dart';
import 'package:realifeapp/video/models/image_model.dart';
import 'package:realifeapp/video/models/like_model.dart';
import 'package:realifeapp/video/models/post_model.dart';
import 'package:path_provider/path_provider.dart';

class VidController extends GetxController {
  AuthController authController = Get.find();

  RxBool filter = RxBool(true);

  Set<String> postId = {};

  RxInt imageCount = RxInt(0);

  final Rx<List<Post>> _videoList = Rx<List<Post>>([]);
  final Rx<List<ImageModel>> imageList = Rx<List<ImageModel>>([]);

  // RxString commentText = RxString('');

  Rx<TextEditingController> commentText = TextEditingController().obs;

  RxBool commentPostLoading = RxBool(false);

  List<Post> get videoList => _videoList.value;

  final Rx<List<Like>> _likesList = Rx<List<Like>>([]);

  List<Like> get likesList => _likesList.value;

  putLike(postId, formWho, toWho) async {
    try {
      DocumentReference ref = firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(formWho);
      Like like = Like(
        id: ref.id,
        createDate: Timestamp.now(),
        fromWho: formWho,
        toWho: toWho,
        postId: postId,
        active: true,
      );
      ref.get().then((value) async {
        if (value.exists) {
          await ref.delete();
        } else {
          await ref.set(
            like.toJson(),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> downloadFileExample(id, url) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$id');
    final ref = FirebaseStorage.instance.ref();
    print(downloadToFile.path);
    await FirebaseStorage.instance.ref(ref.bucket).writeToFile(downloadToFile);
  }

  getPosts() {
    _videoList.bindStream(
      firestore.collection('posts').snapshots().map(
            (QuerySnapshot query) {
          List<Post> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Post.fromFireStore(element),
            );
          }
          return retVal;
        },
      ),
    );
  }

  RxList following = RxList([]);

  getFollowing() async {
    final result = await firestore
        .collection('users')
        .doc(authInstance.currentUser.uid)
        .get();
    result.data()['following'].forEach(
          (val) {
        following.add(val);
      },
    );
  }

  postComment(postId) async {
    if (commentText.value.text.isEmpty) {} else {
      commentPostLoading.value = true;
      final ref = firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();
      ref.set({
        'id': ref.id,
        'avatar': authController.userModel.value.avatar,
        'createDate': Timestamp.now(),
        'ownerId': authInstance.currentUser.uid,
        'ownerName': authController.userModel.value.name,
        'postId': postId,
        'text': commentText.value.text,
        'comments': [],
      }).whenComplete(() {
        commentPostLoading.value = false;
        commentText.value.clear();
      }).catchError((e) {
        commentPostLoading.value = false;
        print(e);
      });
    }
  }

  RxString userName = RxString('');

  getName() async {
    final res = await firestore
        .collection('users')
        .doc(authInstance.currentUser.uid)
        .get();
    final resName = res.data()['name'];
    userName.value = resName;
  }

  @override
  void onInit() {
    super.onInit();
    getName();
    getFollowing();
  }
}
