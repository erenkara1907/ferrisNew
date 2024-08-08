import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class EmptySentDataModel extends INetworkSentDataModel {
  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
