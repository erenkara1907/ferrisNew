import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class InspectionChecklistGetModel extends INetworkSentDataModel {
  final int? jobInspectionId;

  InspectionChecklistGetModel({
    this.jobInspectionId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (jobInspectionId != null) 'jobInspectionId': jobInspectionId,
    };
  }
}
