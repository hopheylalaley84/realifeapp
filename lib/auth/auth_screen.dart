import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/auth/controllers/auth_controller.dart';
import 'package:realifeapp/auth/registration_screen.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends GetWidget<AuthController> {
  const AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 30.w,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: CommonTextWidget(
                    text: 'Welcome to Realife',
                    size: 20,
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FacebookAuthButton(
                        onPressed: () {},
                        isLoading: controller.loginProgressFb.value,
                        text: 'Login Facebook',
                        style: AuthButtonStyle(
                          separator: 25,
                          buttonColor: Color(0xff3A5898),
                          height: 60,
                          width: 300,
                          buttonType: AuthButtonType.secondary,
                          iconType: AuthIconType.secondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: GoogleAuthButton(
                          onPressed: () {
                            controller.loginProgressGoogle.value = true;
                            controller.googleSignIn().whenComplete(() {
                              controller.loginProgressGoogle.value = false;
                            });
                          },
                          isLoading: controller.loginProgressGoogle.value,
                          text: 'Login Google',
                          style: AuthButtonStyle(
                            progressIndicatorColor: Color(0xffE94335),
                            padding: EdgeInsets.only(right: 38),
                            buttonColor: Color(0xffE94335),
                            height: 60,
                            width: 300,
                            buttonType: AuthButtonType.secondary,
                            iconType: AuthIconType.secondary,
                          ),
                        ),
                      ),
                      AppleAuthButton(
                        onPressed: () {},
                        isLoading: controller.loginProgressApple.value,
                        text: 'Login Apple',
                        style: AuthButtonStyle(
                          separator: 25,
                          padding: EdgeInsets.only(right: 55),
                          buttonColor: Color(0xff242529),
                          height: 60,
                          width: 300,
                          buttonType: AuthButtonType.secondary,
                          iconType: AuthIconType.secondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 30),
                        child: Divider(
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [
                                Colors.blue,
                                Colors.blue.shade400,
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            onPressed: () {
                              Get.to(RegistrationScreen());
                            },
                            child: CommonTextWidget(
                              text: 'Registration',
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 25),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "By creating an account, you agree to our",
                            style: TextStyle(fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " Terms of Service ",
                                  style: TextStyle(
                                      color: Color(0xff037FF3), fontSize: 16)),
                              TextSpan(
                                text: " and ",
                                style: TextStyle(fontSize: 16),
                              ),
                              TextSpan(
                                  text: " Privacy Policy ",
                                  style: TextStyle(
                                    color: Color(0xff037FF3),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
