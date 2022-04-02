import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import '../../../app/common/components/common_text_widget.dart';
import 'package:sizer/sizer.dart';

class CommentItemWidget extends StatefulWidget {
  final String avatar;
  final String name;
  final String text;
  final List comments;
  final String postId;
  final String commentId;

  const CommentItemWidget(
      {Key key,
      this.avatar,
      this.name,
      this.text,
      this.comments,
      this.postId,
      this.commentId})
      : super(key: key);

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  List commentsLike = [];

  getCommentsLike() async {
    commentsLike.clear();
    final ref = firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId);
    final res = await ref.get();
    commentsLike.addAll(res.data()['comments']);
    print(commentsLike);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentsLike.clear();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentsLike();
    print(commentsLike);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            child: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  widget.avatar,
                ),
              ),
            ),
            width: 50,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget(
              text: widget.name,
              color: Colors.grey[500],
              size: 10,
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              width: 60.w,
              child: CommonTextWidget(
                text: widget.text,
                color: Colors.black,
                size: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
           await getCommentsLike();
            final ref = firestore
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .doc(widget.commentId);
            List user = [authInstance.currentUser.uid];
            if (!commentsLike.contains(authInstance.currentUser.uid)) {
              ref.update({'comments': FieldValue.arrayUnion(user)});

            } else {
              ref.update({'comments': FieldValue.arrayRemove(user)});
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               commentsLike.contains(authInstance.currentUser.uid) ? const Icon(
                  Icons.favorite_border,
                  size: 20,
                 color: Colors.blue,
                ) : const Icon(
                 Icons.favorite,
                 size: 20,
                 color: Colors.blue,
               ),
                CommonTextWidget(
                  text: widget.comments.length.toString(),
                  size: 10,
                  color: Colors.blue,

                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
