import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonTextWidget extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;

  const CommonTextWidget({
    Key key,
    this.text,
    this.size,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(fontWeight: fontWeight, fontSize: size.sp,color:color,),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
