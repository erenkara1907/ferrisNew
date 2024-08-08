import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class StartJobPostModel extends INetworkSentDataModel {
  final int startDate;

  StartJobPostModel({
    required this.startDate,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
    };
  }
}
