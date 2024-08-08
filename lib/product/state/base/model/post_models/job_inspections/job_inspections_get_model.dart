import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class JobInspectionsGetModel extends INetworkSentDataModel {
  final int? jobId;
  final String? regNumber;

  JobInspectionsGetModel({
    this.jobId,
    this.regNumber,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (jobId != null) 'jobId': jobId,
      if (regNumber != null) 'regNumber': regNumber,
    };
  }
}
