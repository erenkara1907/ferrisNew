import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'job_to_finish.g.dart';

@HiveType(typeId: TypeIds.modelIdJobToFinish)
class JobToFinish {
  JobToFinish({
    required this.id,
    required this.jobJson,
    required this.endJobPostModel,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String jobJson;

  @HiveField(2)
  final EndJobPostModel endJobPostModel;

  factory JobToFinish.withJob({
    String? id,
    required JobsResponseModelItem job,
    required EndJobPostModel endJobPostModel,
  }) {
    return JobToFinish(
      id: id ?? const Uuid().v4(),
      jobJson: job.toJson(),
      endJobPostModel: endJobPostModel,
    );
  }

  JobsResponseModelItem? _jobsResponseModelItem;

  JobsResponseModelItem get job =>
      _jobsResponseModelItem ??= JobsResponseModelItem.fromJson(jobJson);

  JobToFinish copyWith({
    String? id,
    JobsResponseModelItem? job,
    EndJobPostModel? endJobPostModel,
  }) {
    if (job != null) _jobsResponseModelItem = job;
    return JobToFinish(
      id: id ?? this.id,
      jobJson: job?.toJson() ?? jobJson,
      endJobPostModel: endJobPostModel ?? this.endJobPostModel,
    );
  }

  @override
  String toString() {
    return '$runtimeType(id: $id, job: $job, endJobPostModel: $endJobPostModel)';
  }
}
