import 'package:flutter/material.dart';
import 'package:movie_pp/widgets/reusableTextWidget.dart';
import 'package:movie_pp/widgets/reusableTitleWidget.dart';

class FilterMovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Filter Movies',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
