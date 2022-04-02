import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ThemeSettings {
  TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    color: Colors.white,
    fontFamily: Platform.isIOS ? 'SFProTextRegular' : 'Roboto-Regular',
  );

  final headline6TextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    color: const Color(0xff36313C),
    fontFamily: Platform.isIOS ? 'SFProTextRegular' : 'Roboto-Regular',
  );

  final hintTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.sp,
    color: const Color(0xff777777),
    fontFamily: Platform.isIOS ? 'SFProTextRegular' : 'Roboto-Regular',
  );

  final bodyTextStyle1 = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    color: const Color(0xffffffff),
    fontFamily: Platform.isIOS ? 'SFProTextRegular' : 'Roboto-Regular',
  );

  final bodyTextStyle2 = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.sp,
    color: const Color(0xff36313C),
    fontFamily: Platform.isIOS ? 'SFProTextRegular' : 'Roboto-Regular',
  );

  ThemeData setTheme() {
    return ThemeData(
      textTheme: TextTheme(
        headline6: headline6TextStyle,
        bodyText1: bodyTextStyle1,
        bodyText2: bodyTextStyle2,
        headline1: hintTextStyle,
        button: buttonTextStyle,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xff121212),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xffffffff),
        ),
      ),
      primaryColor: const Color(0xff000000),
      backgroundColor: const Color(0xff121212),
      scaffoldBackgroundColor: const Color(0xff121212),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: bodyTextStyle1.copyWith(
            color: Colors.grey[600].withOpacity(0.5), fontSize: 14.sp),
        // floatingLabelBehavior:FloatingLabelBehavior.always,
        labelStyle: bodyTextStyle1.copyWith(
            color: Colors.grey[600],
            fontSize: 14.sp,
            fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide(
              color: Colors.grey[600],
              width: 1,
            )),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
        filled: true,
        fillColor: const Color(0xff242529),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(
            color: Colors.grey[600],
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(
            color: Colors.grey[600],
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[600],
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff3D60DE),
          minimumSize: const Size(double.infinity, 42),
          // side: BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(double.infinity, 42),
          side: const BorderSide(color: Color(0xffffffff), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
