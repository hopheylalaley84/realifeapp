import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:realifeapp/app/bottom_bar.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/auth/auth_screen.dart';
import 'package:realifeapp/auth/models/user_model.dart';
import 'package:realifeapp/video/controllers/vid_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();


  String usersCollection = "users";
  Rx<User> firebaseUser;


  Rx<UserModel> userModel = UserModel().obs;

  GoogleSignInAccount googleUser;

  AndroidDeviceInfo androidInfo;
  IosDeviceInfo iosInfo;

  RxBool loginProgressGoogle = false.obs;
  RxBool loginProgressFb = false.obs;
  RxBool loginProgressApple = false.obs;
  RxBool loginProgressMail = false.obs;

  _setInitialScreen(User user) {
    if (user == null) {
      Get.offAll(() => const AuthScreen());
    } else {
      Get.offAll(() => const BottomBarScreen());
      getAppUser();
    }
  }

  _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    }
  }

  List<String> searchNameForFirebase(String name) {
    List<String> splitList = name.split(' ');
    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    return indexList;
  }

  _addUserToFirestoreMail(String userId, String pass, String mail, String name,
      String phone, String userName, String date) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
      }
      if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
      }

      Map<String, String> packageInfoMap = {
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      };

      Map<String, String> deviceInfoMap = Platform.isAndroid
          ? {
        "os_version": androidInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": androidInfo.model,
        "device": androidInfo.device,
      }
          : Platform.isIOS
          ? {
        "os_version": iosInfo.systemVersion,
        "device": iosInfo.name,
        "model": iosInfo.utsname.machine,
        "platform": 'ios',
      }
          : {'web': 'web'};
      firebaseFirestoreInstance.collection(usersCollection).doc(userId).set(
        {
          "name": name.trim(),
          "userName": userName.trim(),
          "uid": userId,
          "email": mail.trim(),
          'pass': pass.trim(),
          'createDate': FieldValue.serverTimestamp(),
          'deviceInfo': deviceInfoMap,
          'packageInfo': packageInfoMap,
          'phone': phone.trim() ?? '',
          'avatar': avatarUrl,
          'profileStatus': 'free',
          'location': '',
          'dateOfBirth': date,
          'following' : [],
          'followers' : [],
          'searchIndex': searchNameForFirebase(name) ?? [],

        },
      );
    } catch (e) {
      loginProgressMail.value = false;
      Get.snackbar(
        "Что то пошл не так!",
        "Попробуйте позже",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
      );
    }
  }


  _addUserToFirestoreGoogle(String userId, [resUser]) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
      }
      if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
      }

      Map<String, String> packageInfoMap = {
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      };

      Map<String, String> deviceInfoMap = Platform.isAndroid
          ? {
        "os_version": androidInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": androidInfo.model,
        "device": androidInfo.device,
      }
          : Platform.isIOS
          ? {
        "os_version": iosInfo.systemVersion,
        "device": iosInfo.name,
        "model": iosInfo.utsname.machine,
        "platform": 'ios',
      }
          : {'web': 'web'};
      await firebaseFirestoreInstance
          .collection(usersCollection)
          .doc(userId)
          .set(
        {
          "uid": resUser.uid,
          "name": googleUser.displayName,
          "email": googleUser.email,
          'createDate': FieldValue.serverTimestamp(),
          'deviceInfo': deviceInfoMap,
          'packageInfo': packageInfoMap,
          'avatar': googleUser.photoUrl?? avatarUrl,
          'profileStatus': 'free',
          'location': '',
          'dateOfBirth': '',
          'userName': '',
          'following' : [],
          'followers' : [],
          'searchIndex': searchNameForFirebase(googleUser.displayName) ?? [],
        },
      );
    } catch (e) {
      loginProgressGoogle.value = false;
      Get.snackbar(
        "Что то пошл не так!",
        "Попробуйте позже",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
      );
    }
  }

  Future googleSignIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final user = await googleSignIn.signIn();
      if (user == null) {
        loginProgressGoogle.value = false;
        return;
      }
      googleUser = user;
      loginProgressGoogle.value = true;
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await authInstance.signInWithCredential(credential).then(
            (res) {
          _getDeviceInfo();
          if (res.additionalUserInfo.isNewUser) {
            _addUserToFirestoreGoogle(res.user.uid, res.user);
          }
          loginProgressGoogle.value = false;
        },
      );
    } on FirebaseException catch (e) {
      loginProgressGoogle.value = false;
      Get.snackbar(
        "Что то пошл не так!",
        "Попробуйте позже",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
      );
    }
  }

  void signIn(pass, mail, name,
       phone, userName, date) async {
    try {
      loginProgressMail.value = true;
      await authInstance
          .createUserWithEmailAndPassword(
          email: mail.trim(), password: pass.trim())
          .then((result) {
        String userId = result.user.uid;
        _addUserToFirestoreMail(userId,pass, mail, name,
            phone, userName, date);
        if (result.user != null) {
          loginProgressMail.value = false;
        }
      });
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      String errorCode = e.code;
      if (errorCode == 'wrong-password') {
        Get.snackbar(
          "Что то пошл не так!",
          "Неверный пароль",
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ),
        );
        loginProgressMail.value = false;
      } else if (errorCode == 'user-not-found') {
        Get.snackbar(
          "Что то пошл не так!",
          "Почтовый ящик не найден",
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ),
        );
        loginProgressMail.value = false;
      }
      loginProgressMail.value = false;
    }
  }

  void signOut() async {
    authInstance.signOut().whenComplete(() {});
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    googleSignIn.signOut();
  }

  getAppUser()async{
    final res = await firestore.collection('users').doc(authInstance.currentUser.uid).get();
    userModel.value = UserModel.fromSnapshot(res);
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(authInstance.currentUser);
    firebaseUser.bindStream(authInstance.userChanges());
    // getAppUser();
    // appleSignIn();
    ever(firebaseUser, _setInitialScreen);
  }
}
