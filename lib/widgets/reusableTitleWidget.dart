import 'package:flutter/material.dart';

class ReusableTitleWidget extends StatelessWidget {
  const ReusableTitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
