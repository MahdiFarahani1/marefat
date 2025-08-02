import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> getDominantColor(String imageUrl) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(
    NetworkImage(imageUrl),
    size: const Size(200, 200),
  );

  return paletteGenerator.dominantColor?.color ?? Colors.grey.shade300;
}
