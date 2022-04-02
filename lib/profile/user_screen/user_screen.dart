import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/app/controllers/bottom_bar_controller.dart';
import 'package:realifeapp/chat/screens/all_chats_screen.dart';
import 'package:realifeapp/profile/views/screens/prifile_video_screen.dart';
import 'package:realifeapp/profile/views/screens/profile_settings.dart';
import 'package:sizer/sizer.dart';

import '../../../auth/models/user_model.dart';

class UserScreen extends StatefulWidget {
  final String userId;

  const UserScreen({Key key, this.userId}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final BottomBarController barController = Get.put(BottomBarController());

  int likes = 0;

  getLikes() async {
    var result = await firestore
        .collection('posts')
        .where('ownerId', isEqualTo: widget.userId)
        .get();

    for (var element in result.docs) {
      print(result.docs.length);
      var res = element.reference.collection('likes').get();
      res.then((value) {
        likes++;
        setState(() {});
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder(
            stream:
                firestore.collection('users').doc(widget.userId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SizedBox(
                                width: 70,
                                height: 70,
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
                              height: 10,
                            ),
                            CommonTextWidget(
                              text: snapshot.data['name'],
                              fontWeight: FontWeight.w700,
                              size: 18,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder(
                                    stream: firestore
                                  .collection('users')
                                  .doc(widget.userId)
                                  .snapshots(),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                       return Column(
                                          children:  [
                                            CommonTextWidget(
                                              text: snapshot
                                                  .data['following'].length
                                                  .toString(),
                                              fontWeight: FontWeight.normal,
                                              size: 18,
                                            ),
                                            const CommonTextWidget(
                                              text: 'Following',
                                              fontWeight: FontWeight.normal,
                                              size: 12,
                                            ),
                                          ],
                                        );
                                      }
                                      return const SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                      width: 1,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: firestore
                                          .collection('users')
                                          .doc(widget.userId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              CommonTextWidget(
                                                text: snapshot
                                                    .data['followers'].length
                                                    .toString(),
                                                fontWeight: FontWeight.normal,
                                                size: 18,
                                              ),
                                              const CommonTextWidget(
                                                text: 'Followers',
                                                fontWeight: FontWeight.normal,
                                                size: 12,
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                  SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                      width: 1,
                                    ),
                                  ),
                                  Column(
                                    children:  [
                                      CommonTextWidget(
                                        text: likes.toString(),
                                        fontWeight: FontWeight.normal,
                                        size: 18,
                                      ),
                                      const CommonTextWidget(
                                        text: 'Likes',
                                        fontWeight: FontWeight.normal,
                                        size: 12,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 70.w,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () async {
                                  String chatId =
                                      '${authInstance.currentUser.uid}+${widget.userId}';

                                  await firestore
                                      .collection('msg')
                                      .doc(chatId.hashCode.toString())
                                      .set({
                                    'createDate': Timestamp.now(),
                                    'fromWho': authInstance.currentUser.uid,
                                    'toWho': widget.userId,
                                    'id': chatId.hashCode.toString(),
                                    'read': false,
                                  });
                                  Get.to(const AllChatScreen());
                                },
                                child: const CommonTextWidget(
                                  text: 'МESSAGES',
                                  size: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          StreamBuilder(
                              stream: firestore
                                  .collection('users')
                                  .doc(authInstance.currentUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List followers = snapshot.data['following'];
                                  return SizedBox(
                                    width: 20.w,
                                    height: 55,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(const Color(
                                                0xff242529)), //Background Color
                                      ),
                                      onPressed: () async {
                                        if (followers.contains(widget.userId)) {
                                          firestore
                                              .collection('users')
                                              .doc(authInstance.currentUser.uid)
                                              .update({
                                            'following': FieldValue.arrayRemove(
                                                [widget.userId])
                                          }).whenComplete(() {
                                            firestore
                                                .collection('users')
                                                .doc(widget.userId)
                                                .update({
                                              'followers':
                                                  FieldValue.arrayRemove([
                                                authInstance.currentUser.uid
                                              ])
                                            });
                                          });
                                        } else {
                                          firestore
                                              .collection('users')
                                              .doc(authInstance.currentUser.uid)
                                              .update({
                                            'following': FieldValue.arrayUnion(
                                                [widget.userId])
                                          }).whenComplete(() {
                                            firestore
                                                .collection('users')
                                                .doc(widget.userId)
                                                .update({
                                              'followers':
                                                  FieldValue.arrayUnion([
                                                authInstance.currentUser.uid
                                              ])
                                            });
                                          });
                                        }
                                      },
                                      child: followers.contains(widget.userId)
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.group_add),
                                    ),
                                  );
                                }
                                return Container();
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xff242529),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.apps,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StreamBuilder(
                              stream: firestore
                                  .collection('posts')
                                  .where('ownerId', isEqualTo: widget.userId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 15,
                                    children:
                                        snapshot.data.docs.map<Widget>((val) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            ProfileVideoScreen(
                                              url: val['videoUrl'],
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          width: 30.w,
                                          child:
                                              Image.network(val['thumbnail']),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                return Container();
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
