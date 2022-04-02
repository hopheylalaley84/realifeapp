import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/auth/controllers/auth_controller.dart';
import 'package:realifeapp/discover/views/screens/discover_screen.dart';
import 'package:realifeapp/profile/views/screens/profile_screen.dart';
import 'package:realifeapp/video/controllers/video_controller.dart';
import 'package:realifeapp/video/views/screens/video_screen.dart';

import '../../activities/views/screens/watch_screen.dart';

class BottomBarController extends GetxController{

  final VideoController videoController = Get.put(VideoController(),);



  void signOut() async {
    authInstance.signOut().whenComplete(() {});
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    googleSignIn.signOut();
  }

  RxList<Widget> pages = RxList([
    VideoScreen(),
    SearchScreen(),
    Activities(),
    ProfileScreen(),
  ]);


   RxList<IconData> iconList = RxList<IconData>([
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ]);

  RxInt bottomBarIndex = RxInt(0);

  changeBarIndex(index){
    bottomBarIndex = index;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

}