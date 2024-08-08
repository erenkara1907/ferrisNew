import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

/// Model for the data sent to the server when requesting expenses.
class ExpensesGetModel extends INetworkSentDataModel {
  final int? jobId;

  ExpensesGetModel({
    this.jobId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (jobId != null) 'jobId': jobId,
    };
  }
}
