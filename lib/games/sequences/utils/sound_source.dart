import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Encoding scheme for sound references stored alongside a step:
///   - `null`                    → no sound
///   - `asset:<filename>`        → bundled asset under `assets/audio/<filename>`
///   - `file:<filename>`         → user-imported file under
///     `<app documents>/sequence_sounds/<filename>`
///   - bare filename             → legacy asset (treated as asset for BC)
class SoundRef {
  static const String _assetPrefix = 'asset:';
  static const String _filePrefix = 'file:';
  static const String soundsDirName = 'sequence_sounds';

  /// Human-readable label for UI.
  static String displayName(String value) {
    if (value.startsWith(_assetPrefix)) {
      return value.substring(_assetPrefix.length);
    }
    if (value.startsWith(_filePrefix)) {
      return value.substring(_filePrefix.length);
    }
    return value;
  }

  static bool isDeviceFile(String value) => value.startsWith(_filePrefix);

  static String asset(String filename) => '$_assetPrefix$filename';
  static String file(String filename) => '$_filePrefix$filename';

  /// Resolve [value] to an [AudioPlayers] [Source] that can be played.
  static Future<Source?> resolve(String? value) async {
    if (value == null || value.isEmpty) return null;
    if (value.startsWith(_assetPrefix)) {
      return AssetSource('audio/${value.substring(_assetPrefix.length)}');
    }
    if (value.startsWith(_filePrefix)) {
      final dir = await getSoundsDir();
      final filename = value.substring(_filePrefix.length);
      final fullPath = p.join(dir.path, filename);
      if (!await File(fullPath).exists()) return null;
      return DeviceFileSource(fullPath);
    }
    // Legacy: treat as asset name.
    return AssetSource('audio/$value');
  }

  /// Returns (and creates if needed) the directory where user-imported
  /// sound files are copied.
  static Future<Directory> getSoundsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, soundsDirName));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [sourcePath] into the sounds directory using a collision-safe
  /// filename, then returns the encoded `file:<filename>` reference.
  static Future<String> importDeviceFile(String sourcePath) async {
    final dir = await getSoundsDir();
    final ext = p.extension(sourcePath);
    final baseNoExt = p.basenameWithoutExtension(sourcePath);
    var candidate = '$baseNoExt$ext';
    var counter = 1;
    while (await File(p.join(dir.path, candidate)).exists()) {
      candidate = '$baseNoExt ($counter)$ext';
      counter++;
    }
    final destPath = p.join(dir.path, candidate);
    await File(sourcePath).copy(destPath);
    return file(candidate);
  }
}
