import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class StopsGetModel extends INetworkSentDataModel {
  final int? jobId;

  StopsGetModel({
    this.jobId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (jobId != null) 'jobId': jobId,
    };
  }
}
