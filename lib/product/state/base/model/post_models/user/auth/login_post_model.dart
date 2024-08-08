import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

/// model class for post data of login.
final class LoginPostModel extends INetworkSentDataModel {
  final String email;
  final String password;

  LoginPostModel({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
