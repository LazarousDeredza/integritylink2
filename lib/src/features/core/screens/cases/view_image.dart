import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  final String imageUrl;

  MyImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Replace with your desired width
      height: 200, // Replace with your desired height
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }
}
