import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/details/inspection_details_post_model.dart';
import 'package:hive/hive.dart';

part 'inspection_details.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionDetails)
class InspectionDetails {
  @HiveField(0)
  final int inspectionId;

  @HiveField(1)
  final double odoReadingInMiles;

  @HiveField(2)
  final int fuelLevel;

  @HiveField(3)
  final bool synced;

  InspectionDetails({
    required this.inspectionId,
    required this.odoReadingInMiles,
    required this.fuelLevel,
    required this.synced,
  });

  InspectionDetailsPostModel toPostModel() {
    return InspectionDetailsPostModel(
      odoReading: odoReadingInMiles,
      fuelLevel: fuelLevel,
    );
  }

  InspectionDetails copyWith({
    int? inspectionId,
    double? odoReadingInMiles,
    int? fuelLevel,
    bool? synced,
  }) {
    return InspectionDetails(
      inspectionId: inspectionId ?? this.inspectionId,
      odoReadingInMiles: odoReadingInMiles ?? this.odoReadingInMiles,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      synced: synced ?? this.synced,
    );
  }

  @override
  String toString() {
    return 'InspectionDetails{inspectionId: $inspectionId, odoReadingInMiles: $odoReadingInMiles, fuelLevel: $fuelLevel, synced: $synced}';
  }
}
