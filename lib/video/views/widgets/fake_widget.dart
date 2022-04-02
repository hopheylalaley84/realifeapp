import 'package:flutter/material.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/vid_controller.dart';
import '../../models/post_model.dart';

class FakeWidget extends StatelessWidget {
  final Post data;
  final VidController vidController;

  const FakeWidget({Key key, this.data, this.vidController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('posts').doc(data.id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool fake = snapshot.data['fake'];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  firestore
                      .collection('posts')
                      .doc(data.id)
                      .update({'fake': fake == true ? false : true});
                },
                child: Icon(
                  Icons.block,
                  size: 30,
                  color: fake == false ? Colors.white : Colors.red,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Fake',
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
