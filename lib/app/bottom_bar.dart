import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/controllers/bottom_bar_controller.dart';

import '../video/views/screens/add_post_screen.dart';

class BottomBarScreen extends GetWidget<BottomBarController> {
  const BottomBarScreen({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          body: controller.pages[controller.bottomBarIndex.value],

          floatingActionButton: FloatingActionButton(

            backgroundColor: const Color(0xff1396DB),
            onPressed: () {
              Get.to(() =>const AddPostScreen() );
              // controller.videoController.showOptionsDialog(context);
            },
            child: Container(
            width: 60,
            height: 60,
            child: Center(
              child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset('assets/images/logobtn.png')),
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xff003686), Color(0xff1396DB)])
            ),
            ),),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            inactiveColor: Colors.grey[300],
            activeColor: Colors.blue,
            splashRadius: 0,
            backgroundColor: const Color(0xff242529),
              icons: controller.iconList,
              activeIndex: controller.bottomBarIndex.value,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.smoothEdge,
              onTap: (index) => controller.bottomBarIndex.value = index),
          //other params
        );
      },
    );
  }
}
