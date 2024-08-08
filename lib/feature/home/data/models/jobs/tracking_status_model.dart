import 'package:hive/hive.dart';

part 'tracking_status_model.g.dart';

@HiveType(typeId: 115)
class TrackingStatusModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isTrackable;

  TrackingStatusModel({
    required this.id,
    required this.name,
    this.isTrackable = true,
  });

  factory TrackingStatusModel.fromMap(Map<String, dynamic> map) {
    return TrackingStatusModel(
      id: map['id'] as int,
      name: map['name'] as String,
      isTrackable: map['isTrackable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isTrackable': isTrackable,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is TrackingStatusModel) return id == other.id;
    return false;
  }

  @override
  int get hashCode => id;

  @override
  String toString() => toMap().toString();
}
