import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

/// This is the model to post mfa code.
class OtpPostModel extends INetworkSentDataModel {
  final int userId;
  final String token;
  final String code;

  OtpPostModel({
    required this.userId,
    required this.token,
    required this.code,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'token': token,
      'code': code,
    };
  }
}
