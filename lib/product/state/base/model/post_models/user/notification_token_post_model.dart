import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class NotificationTokenPostModel extends INetworkSentDataModel {
  final String deviceToken;

  NotificationTokenPostModel({
    required this.deviceToken,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
    };
  }

  @override
  String toString() => toMap().toString();
}
