import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/controllers/vid_controller.dart';
import 'package:realifeapp/video/models/post_model.dart';
import 'package:realifeapp/video/views/widgets/send_widget.dart';
import 'package:sizer/sizer.dart';
import '../widgets/comment_widget.dart';
import '../widgets/fake_widget.dart';
import '../widgets/like_widget.dart';
import '../widgets/video_player_post.dart';
import '../widgets/video_profile.dart';
import 'package:sizer/sizer.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VidController vidController = Get.find();

  bool filter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: firestore.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List result = snapshot.data.docs;
            List following = [];

            for (var element in result) {
              if (vidController.following.contains(element['ownerId'])) {
                following.add(element);
              }
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                InViewNotifierList(
                  scrollDirection: Axis.vertical,
                  initialInViewIds: const ['0'],
                  isInViewPortCondition: (double deltaTop, double deltaBottom,
                      double viewPortDimension) {
                    return deltaTop < (0.5 * viewPortDimension) &&
                        deltaBottom > (0.5 * viewPortDimension);
                  },
                  itemCount: filter == false ? following.length : result.length,
                  builder: (BuildContext context, int index) {
                    final Post data = filter == false
                        ? Post.fromFireStore(following[index])
                        : Post.fromFireStore(result[index]);
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 7.0),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return InViewNotifierWidget(
                            id: '$index',
                            builder: (BuildContext context, bool isInView,
                                Widget child) {
                              return Stack(
                                children: [
                                  VideoWidget(
                                    image: filter == false
                                        ? following[index]['thumbnail']
                                        : result[index]['thumbnail'],
                                    play: isInView,
                                    url: filter == false
                                        ? following[index]['thumbnail']
                                        : result[index]['videoUrl'],
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: 80,
                                      // margin: EdgeInsets.only(top: size.height / 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          LikeWidget(
                                            data: data,
                                            vidController: vidController,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const SendWidget(),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CommentWidget(
                                            data: data,
                                            vidController: vidController,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: const FaIcon(
                                                  FontAwesomeIcons.share,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              Text(
                                                '10',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FakeWidget(
                                            data: data,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    top: 15.h,
                                    left: 80.w,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: VideoProfileWidget(
                                        userId: data.ownerId,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: CommonTextWidget(
                                      text: data.text.capitalizeFirst,
                                      size: 12,
                                    ),
                                    top: 47.h,
                                    left: 20,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 23.w),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filter = false;
                            });
                          },
                          child: CommonTextWidget(
                            text: 'Following',
                            size: 18,
                            fontWeight: filter == false
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filter = true;
                            });
                          },
                          child: CommonTextWidget(
                            text: 'For you',
                            size: 18,
                            fontWeight: filter == true
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
