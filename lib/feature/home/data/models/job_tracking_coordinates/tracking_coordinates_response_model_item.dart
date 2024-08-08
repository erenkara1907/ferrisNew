import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'tracking_coordinates_response_model_item.g.dart';

@HiveType(typeId: 129)
class TrackingCoordinatesResponseModelItem extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? jobId;
  @HiveField(2)
  final int? addedTime;
  @HiveField(3)
  final double? latitude;
  @HiveField(4)
  final double? longitude;

  TrackingCoordinatesResponseModelItem({
    required this.id,
    required this.jobId,
    required this.addedTime,
    required this.latitude,
    required this.longitude,
  });

  factory TrackingCoordinatesResponseModelItem.fromJson(String json) {
    return TrackingCoordinatesResponseModelItem.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'addedTime': addedTime,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory TrackingCoordinatesResponseModelItem.fromMap(
      Map<String, dynamic> map) {
    return TrackingCoordinatesResponseModelItem(
      id: map['id'] == null ? null : map['id'],
      jobId: map['jobId'] is int? ? map['jobId'] : map['jobId']['id'],
      addedTime: map['addedTime'] == null ? null : map['addedTime'],
      latitude: map['latitude'] is double
          ? map['latitude']
          : double.parse(map['latitude']),
      longitude: map['longitude'] is double
          ? map['longitude']
          : double.parse(map['longitude']),
    );
  }

  @override
  List<Object?> get props => [id, jobId, addedTime, latitude, longitude];
}
