import 'dart:io';

import 'package:ferrisfwt/product/utility/constants/app_defaults.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/manager/utils/util/multipart_file_mixin.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart' as uuid;

part 'stop.g.dart';

@HiveType(typeId: TypeIds.modelIdStop)
@immutable
class Stop with MultipartFileMixin {
  static const String _nameId = 'id';
  static const String _nameJobId = 'jobId';
  static const String _nameReason = 'reason';
  static const String _nameLatitude = 'latitude';
  static const String _nameLongitude = 'longitude';
  static const String _nameImagesLocal = 'imagesLocal';
  static const String _nameSynced = 'synced';
  static const String _nameSyncedStop = 'syncedStop';
  static const String _nameCategory = 'category';

  const Stop({
    required this.id,
    required this.jobId,
    this.reason,
    this.latitude,
    this.longitude,
    required this.imagesLocal,
    required this.synced,
    this.syncedStop,
    this.category,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int jobId;

  @HiveField(2)
  final String? reason;

  @HiveField(3)
  final double? latitude;

  @HiveField(4)
  final double? longitude;

  @HiveField(5)
  final List<String> imagesLocal;

  @HiveField(6)
  final bool synced;

  @HiveField(7)
  final StopsResponseModelItem? syncedStop;

  @HiveField(8)
  final StopCategoriesResponseModelItem? category;

  Map<String, dynamic> toMap() {
    return {
      _nameId: id,
      _nameJobId: jobId,
      _nameReason: reason,
      _nameLatitude: latitude,
      _nameLongitude: longitude,
      _nameImagesLocal: imagesLocal,
      _nameSynced: synced,
      _nameSyncedStop: syncedStop?.toMap(),
      _nameCategory: category?.toMap(),
    };
  }

  factory Stop.fromMap(Map<String, dynamic> map) {
    return Stop(
      id: map[_nameId],
      jobId: map[_nameJobId],
      reason: map[_nameReason] ?? '',
      latitude: map[_nameLatitude],
      longitude: map[_nameLongitude],
      imagesLocal: (map[_nameImagesLocal] as List<String>),
      synced: map[_nameSynced] ?? false,
      syncedStop: map[_nameSyncedStop] != null
          ? StopsResponseModelItem.fromMap(map[_nameSyncedStop])
          : null,
      category: map[_nameCategory] != null
          ? StopCategoriesResponseModelItem.fromMap(map[_nameCategory])
          : null,
    );
  }

  /// Creates an empty stop with the given job id.
  factory Stop.empty(int jobId) {
    return Stop(
      id: const uuid.Uuid().v4(),
      jobId: jobId,
      reason: '',
      latitude: null,
      longitude: null,
      imagesLocal: const [],
      synced: false,
      syncedStop: null,
    );
  }

  /// Creates a stop from the given response model.
  /// [id] is the id of the stop in the local database.
  /// [imagesLocal] is the list of images of the stop in the local file system.
  /// [isSynced] is true if the stop is synced with the server.
  /// other fields are taken from the [data].
  factory Stop.fromResponseModel(
    StopsResponseModelItem data, {
    required String id,
    required List<String> imagesLocal,
    isSynced = true,
  }) {
    final map = data.toMap();
    map[_nameSyncedStop] = {...map}; // deep copy
    map[_nameId] = id;
    map[_nameSynced] = isSynced;
    map[_nameImagesLocal] = imagesLocal;
    return Stop.fromMap(map);
  }

  String get displayName {
    return '$reason - ${imagesLocal.length} images';
  }

  /// Returns true if this stop has a difference with the other stop.
  bool hasDiff(Stop other) {
    return jobId != other.jobId ||
        reason != other.reason ||
        imagesLocal.length != other.imagesLocal.length ||
        imagesLocal.any((element) => !other.imagesLocal.contains(element));
  }

  bool isSynced() {
    if (syncedStop == null) return false;
    return synced;
  }

  /// Returns true if this stop is empty.
  bool get isEmpty {
    return category == null && imagesLocal.isEmpty;
  }

  @override
  String toString() {
    return 'Stop(id: $id, jobId: $jobId, reason: $reason, images: $imagesLocal)';
  }
}
