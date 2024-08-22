import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../utility/error_handler/sentry_error_handler.dart';

@immutable
final class FileOperation {
  const FileOperation._();
  static FileOperation? _operation;
  static FileOperation get instance {
    _operation ??= const FileOperation._();
    return _operation!;
  }

  Future<Directory> _fileDirectory(String path) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;

    final dirPath = p.join(appDocPath, path);
    final newDirectory = Directory(dirPath);
    return newDirectory;
  }

  Future<String> createSubDirectory(String path) async {
    try {
      final newDirectory = await _fileDirectory(path);

      if (!await newDirectory.exists()) {
        await newDirectory.create();
      }
      return newDirectory.path;
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      throw Exception(e);
    }
  }

  Future<bool> removeSubDirectory(String path) async {
    try {
      final newDirectory = await _fileDirectory(path);

      if (await newDirectory.exists()) {
        await newDirectory.delete();
      }
      return true;
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return false;
    }
  }
}
