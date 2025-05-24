import 'package:autozone/presentation/theme/colors.dart';
import 'package:flutter/material.dart';


class TitleText extends StatelessWidget {
  final String text;
  const TitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: appFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: autoGray900,
      ),
    );
  }
}

const String appFontFamily = 'Roboto';
