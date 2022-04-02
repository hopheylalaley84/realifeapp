import 'package:flutter/material.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/models/like_model.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/vid_controller.dart';
import '../../models/post_model.dart';

class LikeWidget extends StatelessWidget {
  final Post data;
  final VidController vidController;

  const LikeWidget({Key key, this.data, this.vidController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('posts')
          .doc(data.id)
          .collection('likes')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List likes = snapshot.data.docs.map((val) => val['fromWho']).toList();
          bool userLike = likes.contains(authInstance.currentUser.uid);

          return Column(
            children: [
              InkWell(
                onTap: () {
                  vidController.putLike(
                      data.id, authInstance.currentUser.uid, data.ownerId);
                },
                child: Icon(
                  Icons.favorite,
                  size: 30,
                  color: userLike != true
                      ? Colors.white
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                snapshot.data.docs.length.toString(),
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
                Icons.favorite,
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
