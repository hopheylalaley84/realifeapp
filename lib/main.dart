import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/app/controllers/bottom_bar_controller.dart';
import 'package:realifeapp/auth/controllers/auth_controller.dart';
import 'package:realifeapp/auth/start_app_screen.dart';
import 'package:sizer/sizer.dart';
import 'app/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializationFirebase.then((_) {
    Get.put(AuthController(),permanent: true);
    Get.put(BottomBarController(),permanent: true);
  });

  runApp(
    Sizer(
      builder: (context, snapshot, dev) {
        return const RealifeApp();
      },
    ),
  );
}

class RealifeApp extends StatelessWidget {
  const RealifeApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeSettings().setTheme(),
      title: 'RealifeApp',
      home: StartScreen(),
    );
  }
}
