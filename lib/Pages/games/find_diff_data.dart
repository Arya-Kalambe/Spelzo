import 'package:flutter/material.dart';

class FindDiffLevel {
  final String originalImage;
  final String editedImage;
  final List<Offset> spots;

  FindDiffLevel({
    required this.originalImage,
    required this.editedImage,
    required this.spots,
  });
}

final List<FindDiffLevel> levels = [
  FindDiffLevel(
    originalImage: 'assets/images/level1_original.jpg',
    editedImage: 'assets/images/level1_edited.jpg',
    spots: [Offset(500, 300), Offset(180, 150), Offset(250, 50)],
  ),
  FindDiffLevel(
    originalImage: 'assets/images/level2_original.jpg',
    editedImage: 'assets/images/level2_edited.jpg',
    spots: [Offset(60, 90), Offset(210, 130), Offset(150, 60)],
  ),
];