// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CenterImage extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;

  const CenterImage({Key? key, required this.imagePath,required this.isNetworkImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // width: 200,
        // height: 200,
        child: isNetworkImage ? Image.network(
          imagePath,
          scale: 0.6,
        ) :Image.asset(
          imagePath,
          scale: 0.3,
        ),
      ),
    );
  }
}
