import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

mixin MultipartFileMixin {
  /// Returns a [MultipartFile] from the given [path].
  Future<MultipartFile?> getMultipartFileFromPath(String? path) async {
    if (path == null) return null;
    final file = File(path);
    return MultipartFile.fromFileSync(
      file.path,
      filename: basename(path),
    );
  }

  /// Returns a nonnull [MultipartFile] from the given [path]
  Future<MultipartFile> getMultipartFileFromPathNonNull(String path) async {
    final result = await getMultipartFileFromPath(path);
    return result!;
  }
}
