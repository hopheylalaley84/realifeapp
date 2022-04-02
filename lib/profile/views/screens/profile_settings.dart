import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/profile/views/screens/accaunt_screen.dart';
import 'package:realifeapp/profile/views/widgets/profilea_ava_widget.dart';
import 'package:realifeapp/video/views/widgets/video_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonTextWidget(
          text: 'SETTINGS',
          size: 15,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvaWidget(
              userId: authInstance.currentUser.uid,
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              color: const Color(0xff242529),
              child: InkWell(
                onTap: (){
                  Get.to(const AccauntScreen());
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xff242529),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextButton.icon(
                          onPressed: () {
                            Get.to(const AccauntScreen());

                          },
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                          label: const CommonTextWidget(
                            text: 'Account',
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xff242529),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.beenhere,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const CommonTextWidget(
                        text: 'Privacy',
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xff242529),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.block,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const CommonTextWidget(
                        text: 'Bloc',
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xff242529),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.help,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const CommonTextWidget(
                        text: 'help',
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
