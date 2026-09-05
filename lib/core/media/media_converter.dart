import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

/// Converts picked media to backend-accepted formats and enforces the size cap.
///
/// The backend rejects anything that isn't mp4 (video) or jpg/jpeg/png (image)
/// — iPhones hand us `.mov` video and `.heic` photos, which is what trips the
/// "This file type is not allowed" error. These helpers re-encode to mp4 / jpg.
class MediaConverter {
  MediaConverter._();

  /// Max allowed size for a video or image sent to the backend (100 MB).
  static const int maxBytes = 100 * 1024 * 1024;

  static const Set<String> _imageOk = {'jpg', 'jpeg', 'png'};

  static String _ext(String path) {
    final slash = path.lastIndexOf(Platform.pathSeparator);
    final name = slash == -1 ? path : path.substring(slash + 1);
    final dot = name.lastIndexOf('.');
    return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  }

  /// True when [path] isn't already jpg/jpeg/png.
  static bool isImageConversionNeeded(String path) =>
      !_imageOk.contains(_ext(path));

  /// Ensures [path] is a jpg/png, converting (to jpg) if needed. Returns the
  /// path to use — the original when no conversion was required.
  static Future<String> ensureJpgOrPng(String path) async {
    if (!isImageConversionNeeded(path)) return path;
    final dir = await getTemporaryDirectory();
    final target =
        '${dir.path}/amanah_${DateTime.now().microsecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      target,
      quality: 90,
    );
    if (result == null) {
      throw const MediaConversionException('Could not convert image.');
    }
    return result.path;
  }

  /// Compresses [path] to a medium-quality mp4. Always re-encodes — even an
  /// already-mp4 file (e.g. Android camera clips) — because the raw capture is
  /// far too large to upload reliably. [onProgress] reports 0..1. Returns the
  /// compressed file's path.
  static Future<String> ensureMp4(
    String path, {
    void Function(double progress)? onProgress,
  }) async {
    final sub = VideoCompress.compressProgress$.subscribe((p) {
      onProgress?.call((p / 100).clamp(0.0, 1.0));
    });
    try {
      final info = await VideoCompress.compressVideo(
        path,
        quality: VideoQuality.MediumQuality,
        includeAudio: true,
      );
      final out = info?.file?.path;
      if (out == null) {
        throw const MediaConversionException('Could not convert video.');
      }
      return out;
    } finally {
      sub.unsubscribe();
    }
  }

  /// Whether the file at [path] is within [maxBytes].
  static Future<bool> withinLimit(String path) async =>
      await File(path).length() <= maxBytes;
}

/// Thrown when a media file can't be converted to an accepted format.
class MediaConversionException implements Exception {
  const MediaConversionException(this.message);
  final String message;

  @override
  String toString() => 'MediaConversionException: $message';
}
