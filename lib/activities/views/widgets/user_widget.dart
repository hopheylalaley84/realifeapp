import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/profile/user_screen/user_screen.dart';

import '../../../chat/screens/all_chats_screen.dart';

class UserActivWidget extends StatelessWidget {
  final String userId;
  final String name;
  final String text;

  const UserActivWidget({Key key, this.userId, this.name, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Get.to(() => UserScreen(
                      userId: userId,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data['avatar'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget(
                              text: snapshot.data['name'],
                              fontWeight: FontWeight.w700,
                              size: 12,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const CommonTextWidget(
                              text: 'text',
                              fontWeight: FontWeight.normal,
                              size: 10,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // CommonTextWidget(text: 'Message',size: 12,)
                    SizedBox(
                      width: 90,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async{
                          String chatId =
                                '${authInstance.currentUser.uid}+$userId';

                            await firestore
                                .collection('msg')
                                .doc(chatId.hashCode.toString())
                                .set({
                              'createDate': Timestamp.now(),
                              'fromWho': authInstance.currentUser.uid,
                              'toWho': userId,
                              'id': chatId.hashCode.toString(),
                              'read': false,
                            });
                            Get.to(const AllChatScreen());
                        },
                        child: const CommonTextWidget(
                          text: 'Message',
                          size: 10,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}
