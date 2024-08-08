import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';

/// Response model for jobs. includes a list of [JobsResponseModelItem].
class JobsResponseModel implements IResponseModel {
  final List<JobsResponseModelItem> jobs;

  JobsResponseModel({
    required this.jobs,
  });

  factory JobsResponseModel.fromMapList(
    List<Map<String, dynamic>> mapList,
  ) {
    final jobs = List<JobsResponseModelItem>.generate(mapList.length, (index) {
      return JobsResponseModelItem.fromMap(mapList[index]);
    });
    return JobsResponseModel(jobs: jobs);
  }

  @override
  String toString() => 'JobsResponseModel(jobs: $jobs)';
}
