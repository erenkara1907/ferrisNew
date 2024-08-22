import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'job_inspection_type.g.dart';

@HiveType(typeId: 202)
class JobInspectionType extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;

  const JobInspectionType({
    required this.id,
    this.name,
  });

  factory JobInspectionType.fromMap(Map<String, dynamic> map) {
    return JobInspectionType(
      id: map['id'] as int,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
