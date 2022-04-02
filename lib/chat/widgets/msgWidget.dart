import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';

class MsgWidget extends StatelessWidget {
  final String usrId;
  final String senderId;
  const MsgWidget({Key key,this.usrId,this.senderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestore.collection('users').doc(senderId != authInstance.currentUser.uid ? senderId : usrId).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CachedNetworkImage(
                    imageUrl:snapshot.data['avatar'],
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
                    text: snapshot.data['name'],
                    fontWeight: FontWeight.w700,
                    size: 12,
                  ),

                ],
              )
            ],
          );
        }return Container();

      }
    );
  }
}
