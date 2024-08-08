import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class LogoutPostModel extends INetworkSentDataModel {
  final String? deviceToken;

  LogoutPostModel({
    this.deviceToken,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (deviceToken != null) 'deviceToken': deviceToken,
    };
  }

  @override
  String toString() => toMap().toString();
}
