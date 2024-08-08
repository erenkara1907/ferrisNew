import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

class FileAdapter extends TypeAdapter<File> {
  @override
  final typeId = 44; // Put an ID you didn't use yet.

  @override
  File read(BinaryReader reader) {
    return File.fromUri(Uri.parse(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, File obj) {
    writer.writeString(obj.uri.toString());
  }
}
