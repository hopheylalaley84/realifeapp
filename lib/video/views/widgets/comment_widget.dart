import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/views/widgets/comment_item_widget.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/vid_controller.dart';
import '../../models/post_model.dart';

class CommentWidget extends StatefulWidget {
  final Post data;
  final VidController vidController;

  const CommentWidget({Key key, this.data, this.vidController})
      : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  String text;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('posts')
          .doc(widget.data.id)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 20),
                            //   child: Container(
                            //     height: 6,
                            //     width: 50,
                            //     decoration:  BoxDecoration(
                            //       color: Colors.grey[300],
                            //       borderRadius: const BorderRadius.all(
                            //         Radius.circular(12),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding:  EdgeInsets.only(left: 30.w,right: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder(
                                    stream: firestore.collection('posts').doc(widget.data.id).collection('comments').snapshots(),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return CommonTextWidget(
                                          text: '${snapshot.data.docs.length}  Comments',
                                          size: 20,
                                          color: Colors.black,
                                        );
                                      }
                                      return Container();
                                    }
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 30,
                                      ))
                                ],
                              ),
                            ),
                            StreamBuilder(
                                stream: firestore
                                    .collection('posts')
                                    .doc(widget.data.id)
                                    .collection('comments')
                                    .orderBy('createDate', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Expanded(
                                      child: ListView(
                                        children: snapshot.data.docs
                                            .map<Widget>((item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: CommentItemWidget(
                                              avatar: item['avatar'],
                                              name: item['ownerName'],
                                              text: item['text'],
                                              comments: item['comments'],
                                              postId: widget.data.id,
                                              commentId: item.id,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                        child: CircleAvatar(
                                          child: ClipOval(
                                            child: Image.network(
                                              authInstance
                                                      .currentUser.photoURL ??
                                                  widget
                                                      .vidController
                                                      .authController
                                                      .userModel
                                                      .value
                                                      .avatar,
                                            ),
                                          ),
                                        ),
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 8, left: 5),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1,
                                          ),
                                        ),
                                        // suffixIcon: Row(
                                        //   children: const [
                                        //     Icon(Icons.alternate_email,color: Colors.blue,),
                                        //     SizedBox(width: 4,),
                                        //     Padding(
                                        //       padding: EdgeInsets.only(right: 4),
                                        //       child: Icon(Icons.tag_faces,color: Colors.blue,),
                                        //     ),
                                        //
                                        //   ],
                                        //   mainAxisAlignment: MainAxisAlignment.end,
                                        // )
                                      ),
                                      controller: widget
                                          .vidController.commentText.value,
                                    ),
                                    width: 68.w,
                                    height: 40,
                                  ),
                                  GestureDetector(
                                    onTap: widget.vidController
                                                .commentPostLoading.value ==
                                            true
                                        ? null
                                        : () {
                                            widget.vidController
                                                .postComment(widget.data.id);
                                          },
                                    child: Obx(() {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xff037FF3)),
                                          child: widget
                                                      .vidController
                                                      .commentPostLoading
                                                      .value ==
                                                  true
                                              ? const Center(
                                                  child: SizedBox(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                      width: 15,
                                                      height: 15),
                                                )
                                              : const Icon(
                                                  Icons.keyboard_arrow_up,
                                                  color: Colors.white,
                                                ),
                                          width: 50,
                                          height: 40,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const FaIcon(
                  FontAwesomeIcons.solidComment,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                snapshot1.data.docs.length.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              )
            ],
          );
        }
        return Column(
          children: [
            const InkWell(
              child: Icon(
                Icons.comment,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            )
          ],
        );
      },
    );
  }
}
