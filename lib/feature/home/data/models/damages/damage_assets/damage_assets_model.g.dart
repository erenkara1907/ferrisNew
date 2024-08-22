// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_assets_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamageAssetsModelAdapter extends TypeAdapter<DamageAssetsModel> {
  @override
  final int typeId = 120;

  @override
  DamageAssetsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamageAssetsModel(
      id: fields[0] as int?,
      mainClientId: fields[1] as int?,
      name: fields[2] as String?,
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
      categories: (fields[5] as List?)?.cast<Categories>(),
    );
  }

  @override
  void write(BinaryWriter writer, DamageAssetsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mainClientId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageAssetsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 121;

  @override
  Categories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categories(
      id: fields[0] as int?,
      name: fields[1] as String?,
      parts: (fields[2] as List?)?.cast<Parts>(),
    );
  }

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.parts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartsAdapter extends TypeAdapter<Parts> {
  @override
  final int typeId = 122;

  @override
  Parts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parts(
      id: fields[0] as int?,
      name: fields[1] as String?,
      categoryId: fields[2] as int?,
      issues: (fields[3] as List?)?.cast<Issues>(),
    );
  }

  @override
  void write(BinaryWriter writer, Parts obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.issues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssuesAdapter extends TypeAdapter<Issues> {
  @override
  final int typeId = 123;

  @override
  Issues read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Issues(
      id: fields[0] as int?,
      name: fields[1] as String?,
      partId: fields[2] as int?,
      failures: (fields[3] as List?)?.cast<Failures>(),
    );
  }

  @override
  void write(BinaryWriter writer, Issues obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.partId)
      ..writeByte(3)
      ..write(obj.failures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FailuresAdapter extends TypeAdapter<Failures> {
  @override
  final int typeId = 124;

  @override
  Failures read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Failures(
      id: fields[0] as int?,
      name: fields[1] as String?,
      issueId: fields[2] as int?,
      repairs: (fields[3] as List?)?.cast<Repairs>(),
    );
  }

  @override
  void write(BinaryWriter writer, Failures obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.issueId)
      ..writeByte(3)
      ..write(obj.repairs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailuresAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepairsAdapter extends TypeAdapter<Repairs> {
  @override
  final int typeId = 125;

  @override
  Repairs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repairs(
      id: fields[0] as int?,
      name: fields[1] as String?,
      failureId: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Repairs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.failureId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebugAdapter extends TypeAdapter<Debug> {
  @override
  final int typeId = 126;

  @override
  Debug read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Debug(
      timestamp: fields[0] as String?,
      memoryUsageMb: fields[1] as double?,
      requestMethod: fields[2] as String?,
      requestUri: fields[3] as String?,
      requestQuery: fields[4] as RequestQuery?,
      requestIp: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Debug obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.memoryUsageMb)
      ..writeByte(2)
      ..write(obj.requestMethod)
      ..writeByte(3)
      ..write(obj.requestUri)
      ..writeByte(4)
      ..write(obj.requestQuery)
      ..writeByte(5)
      ..write(obj.requestIp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebugAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RequestQueryAdapter extends TypeAdapter<RequestQuery> {
  @override
  final int typeId = 127;

  @override
  RequestQuery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestQuery(
      authUser: fields[0] as AuthUser?,
    );
  }

  @override
  void write(BinaryWriter writer, RequestQuery obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.authUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestQueryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthUserAdapter extends TypeAdapter<AuthUser> {
  @override
  final int typeId = 128;

  @override
  AuthUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthUser(
      id: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      mainClientId: fields[3] as DamageAssetsMainClientId?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.mainClientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DamageAssetsMainClientIdAdapter
    extends TypeAdapter<DamageAssetsMainClientId> {
  @override
  final int typeId = 133;

  @override
  DamageAssetsMainClientId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamageAssetsMainClientId(
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DamageAssetsMainClientId obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageAssetsMainClientIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
