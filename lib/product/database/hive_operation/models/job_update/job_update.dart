import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'job_update.g.dart';

@HiveType(typeId: TypeIds.modelIdJobUpdate)
class JobUpdate {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int jobId;

  @HiveField(2)
  final bool isSynced;

  @HiveField(3)
  final int timestamp;

  @HiveField(4)
  final int? trackingStatusId;

  @HiveField(5)
  final int? fuelChargeLevelDelivery;

  @HiveField(6)
  final int? fuelChargeLevelCollection;

  @HiveField(7)
  final String? vehicleFeedback;

  @HiveField(8)
  final String? customerFeedback;

  JobUpdate({
    required this.uuid,
    required this.jobId,
    required this.isSynced,
    required this.timestamp,
    this.trackingStatusId,
    this.fuelChargeLevelDelivery,
    this.fuelChargeLevelCollection,
    this.vehicleFeedback,
    this.customerFeedback,
  });

  factory JobUpdate.fromUpdateJobStatusPostModel({
    String? uuid,
    required int jobId,
    required bool isSynced,
    required int timestampInSec,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  }) {
    return JobUpdate(
      uuid: uuid ?? const Uuid().v4(),
      jobId: jobId,
      isSynced: isSynced,
      timestamp: timestampInSec,
      trackingStatusId: updateJobStatusPostModel.trackingStatusId,
      fuelChargeLevelDelivery: updateJobStatusPostModel.fuelChargeLevelDelivery,
      fuelChargeLevelCollection:
          updateJobStatusPostModel.fuelChargeLevelCollection,
      vehicleFeedback: updateJobStatusPostModel.vehicleFeedback,
      customerFeedback: updateJobStatusPostModel.customerFeedback,
    );
  }

  UpdateJobStatusPostModel get asUpdateJobStatusPostModel {
    return UpdateJobStatusPostModel(
      timestamp: timestamp.toString(),
      trackingStatusId: trackingStatusId,
      fuelChargeLevelDelivery: fuelChargeLevelDelivery,
      fuelChargeLevelCollection: fuelChargeLevelCollection,
      vehicleFeedback: vehicleFeedback,
      customerFeedback: customerFeedback,
    );
  }

  JobUpdate copyWith({
    String? uuid,
    int? jobId,
    bool? isSynced,
    int? timestamp,
    int? trackingStatusId,
    int? fuelChargeLevelDelivery,
    int? fuelChargeLevelCollection,
    String? vehicleFeedback,
    String? customerFeedback,
  }) {
    return JobUpdate(
      uuid: uuid ?? this.uuid,
      jobId: jobId ?? this.jobId,
      isSynced: isSynced ?? this.isSynced,
      timestamp: timestamp ?? this.timestamp,
      fuelChargeLevelDelivery:
          fuelChargeLevelDelivery ?? this.fuelChargeLevelDelivery,
      fuelChargeLevelCollection:
          fuelChargeLevelCollection ?? this.fuelChargeLevelCollection,
      trackingStatusId: trackingStatusId ?? this.trackingStatusId,
      vehicleFeedback: vehicleFeedback ?? this.vehicleFeedback,
      customerFeedback: customerFeedback ?? this.customerFeedback,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'jobId': jobId,
      'isSynced': isSynced,
      'timestamp': timestamp,
      'trackingStatusId': trackingStatusId,
      'fuelChargeLevelDelivery': fuelChargeLevelDelivery,
      'fuelChargeLevelCollection': fuelChargeLevelCollection,
      'vehicleFeedback': vehicleFeedback,
      'customerFeedback': customerFeedback,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';
}
