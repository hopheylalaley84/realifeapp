import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/models/comment_model.dart';
import 'package:realifeapp/video/views/widgets/comment_item_widget.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/vid_controller.dart';
import '../../models/post_model.dart';

class SendWidget extends StatefulWidget {
  final Post data;
  final VidController vidController;

  const SendWidget({Key key, this.data, this.vidController})
      : super(key: key);

  @override
  State<SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const InkWell(
          child:FaIcon(FontAwesomeIcons.solidPaperPlane,size: 28,color: Colors.white,)
        ),
        const SizedBox(height: 7),
        Text(
          '10',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
