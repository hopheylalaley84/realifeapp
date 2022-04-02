import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/profile/views/screens/prifile_video_screen.dart';
import 'package:realifeapp/video/models/post_model.dart';
import 'package:sizer/sizer.dart';

import '../../../profile/user_screen/user_screen.dart';

class UserWidget extends StatefulWidget {
  final String userId;
  final String text;
  final List posts;

  const UserWidget({
    Key key,
    this.userId,
    this.text,
    this.posts,
  }) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff242529),
      child: Column(
        children: [
          StreamBuilder(
              stream:
                  firestore.collection('users').doc(widget.userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const Spacer(),
                        StreamBuilder(
                            stream: firestore
                                .collection('users')
                                .doc(widget.userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List followers = snapshot.data['followers'];
                                return SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => UserScreen(userId:widget.userId),);

                                    },
                                    child:
                                     Text(
                                            '${followers.length} +',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  width: 60,
                                  height: 30,
                                );
                              }
                              return Container();
                            }),
                      ],
                    ),
                  );
                }
                return Container();
              }),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.posts.where((element) => element['ownerId'] == widget.userId).map<Widget>((val) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ProfileVideoScreen(
                        url: val['videoUrl'],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30.w,
                      child: Image.network(val['thumbnail']),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
