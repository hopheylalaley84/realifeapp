import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/auth/controllers/auth_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  AuthController authController = Get.put(AuthController());

  var formKey = GlobalKey<FormState>();
  bool loading = false;

  String username;
  String fullName;
  String email;
  String phone;
  String date;
  String pass;

  void savePassDate1(val) {
    date = val.toString().substring(0, 10);
    setState(() {});
  }

  void datePicker(context,) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: const DatePickerTheme(
          doneStyle: TextStyle(
            color: Color(
              0xff3C6FE4,
            ),
            fontWeight: FontWeight.w700,
          ),
          cancelStyle: TextStyle(
            color: Color(0xff49536D),
          ),
        ),
        onConfirm: (date) {
          savePassDate1(date);
        },
        currentTime: DateTime.now(),
        locale: LocaleType.ru);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onVerticalDragDown,
        GestureType.onVerticalDragStart,
      ],
      child: Scaffold(
        appBar: AppBar(
          title: CommonTextWidget(
            text: 'REGISTRATION',
            size: 14,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: 'User name',
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        onSaved: (val) {
                          username = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.redAccent),
                          hintText: '@Username',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: 'Full name',
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        onSaved: (val) {
                          fullName = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.redAccent),
                          hintText: 'John Doe',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: 'E-mail',
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        onSaved: (val) {
                          email = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.redAccent),
                          hintText: 'johndoe@mail.com',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: 'Phone',
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        onSaved: (val) {
                          phone = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your phone';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.redAccent),
                          hintText: '0545675678',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: 'Date of birth',
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        readOnly: true,
                        onTap: () {
                          datePicker(
                            context,
                          );

                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintStyle:
                            const TextStyle(color: Color(0xff49536D)),
                            suffixIcon: const Icon(Icons.calendar_today),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText:date ?? '09/09/1987',
                            hintText: date ?? 'dd.mm.yyyy'),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget(
                            text: 'Password',
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            onSaved: (val) {
                              pass = val;
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter password';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.redAccent),
                              hintText: '***',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
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
                        child: Obx(() {
                          return ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            onPressed:
                            authController.loginProgressMail.value == true
                                ? null
                                : () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                authController.signIn(pass, email,
                                    fullName, phone, username, date);
                              }
                            },
                            child: authController.loginProgressMail.value ==
                                true
                                ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                                : CommonTextWidget(
                              text: 'Registration',
                              size: 14,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
