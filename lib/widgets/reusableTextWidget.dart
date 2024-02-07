import 'package:flutter/material.dart';

class ReusableTextWidget extends StatelessWidget {
  const ReusableTextWidget(
      {super.key, required this.title, this.width = 100, this.fontSize = 11});
  final String title;
  final double width;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }
}
