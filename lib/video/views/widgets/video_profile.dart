import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/auth/models/user_model.dart';
import 'package:realifeapp/profile/user_screen/user_screen.dart';

class VideoProfileWidget extends StatelessWidget {
  final userId;

  const VideoProfileWidget({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(UserScreen(userId: userId,),);
      },
      child: StreamBuilder(
          stream: firestore
              .collection('users')
              .where('uid', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List users = snapshot.data.docs
                  .map((val) => UserModel.fromSnapshot(val))
                  .toList();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: CachedNetworkImage(
                        imageUrl: users.first.avatar,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        text: users.first.name,
                        fontWeight: FontWeight.w700,
                        size: 12,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const CommonTextWidget(
                        text: 'location',
                        fontWeight: FontWeight.normal,
                        size: 10,
                      ),
                    ],
                  )
                ],
              );
            }
            return Container();
          }),
    );
  }
}
