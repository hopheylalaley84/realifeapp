import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../video/controllers/vid_controller.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff000000),
      body: SafeArea(
        child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff00DB4D),
              color: Colors.white,
            )),
      ),
    );
  }
}