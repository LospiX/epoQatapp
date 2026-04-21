// Run with:  flutter test test/tools/generate_app_icon_test.dart
//
// Rasterizes `assets/icon/epoQatApp_logo.svg` into:
//   - assets/app_icon.png            (1024x1024, black background, full logo)
//   - assets/app_icon_foreground.png (1024x1024, transparent, logo inset ~30%)
//
// After running it once, regenerate per-platform launcher icons with:
//   flutter pub run flutter_launcher_icons

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const String _svgPath = 'assets/icon/epoQatApp_logo.svg';
const double _iconSize = 1024;
// Android adaptive icons require ~66% safe zone — render foreground at 60%
// and leave the rest as padding.
const double _foregroundScale = 0.6;

Future<ui.Image> _rasterize({
  required String svgString,
  required Color? background,
  required double size,
  required double logoScale,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Background fill
  if (background != null) {
    final paint = Paint()..color = background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size, size), paint);
  }

  final loader = SvgStringLoader(svgString);
  final pictureInfo = await vg.loadPicture(loader, null);
  final svgSize = pictureInfo.size;

  // Scale so the SVG fits inside a square of (size * logoScale),
  // preserving aspect ratio, and centered.
  final targetSide = size * logoScale;
  final scale = (targetSide / svgSize.width)
      .clamp(0.0, targetSide / svgSize.height);
  final drawnW = svgSize.width * scale;
  final drawnH = svgSize.height * scale;
  final dx = (size - drawnW) / 2;
  final dy = (size - drawnH) / 2;

  canvas.save();
  canvas.translate(dx, dy);
  canvas.scale(scale);
  canvas.drawPicture(pictureInfo.picture);
  canvas.restore();

  pictureInfo.picture.dispose();

  final picture = recorder.endRecording();
  final image =
      await picture.toImage(size.toInt(), size.toInt());
  picture.dispose();
  return image;
}

Future<void> _writePng(ui.Image image, String outPath) async {
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytes == null) {
    throw StateError('Failed to encode PNG for $outPath');
  }
  final file = File(outPath);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(bytes.buffer.asUint8List());
  stdout.writeln('Wrote $outPath (${bytes.lengthInBytes} bytes)');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate app icon PNGs from SVG', () async {
    final svgBytes = await rootBundle.load(_svgPath);
    final svgString =
        String.fromCharCodes(svgBytes.buffer.asUint8List());

    // Main icon: full-bleed logo on black background.
    final mainImage = await _rasterize(
      svgString: svgString,
      background: const Color(0xFF000000),
      size: _iconSize,
      logoScale: 0.9,
    );
    await _writePng(mainImage, 'assets/app_icon.png');

    // Android adaptive foreground: transparent background, inset.
    final fgImage = await _rasterize(
      svgString: svgString,
      background: null,
      size: _iconSize,
      logoScale: _foregroundScale,
    );
    await _writePng(fgImage, 'assets/app_icon_foreground.png');
  });
}
