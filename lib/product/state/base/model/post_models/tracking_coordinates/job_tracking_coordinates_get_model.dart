import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class JobTrackingCoordinatesGetModel extends INetworkSentDataModel {
  final int? jobId;

  JobTrackingCoordinatesGetModel({
    this.jobId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
    };
  }
}
