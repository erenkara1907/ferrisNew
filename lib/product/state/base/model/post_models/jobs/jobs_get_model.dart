import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class JobsGetModel extends INetworkSentDataModel {
  final String? regNumber;

  JobsGetModel({
    this.regNumber,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'regNumber': regNumber,
    };
  }
}
