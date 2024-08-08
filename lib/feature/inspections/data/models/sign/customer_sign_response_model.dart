import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'customer_sign_response_model.g.dart';

@HiveType(typeId: TypeIds.modelIdCustomerSignResponse)
class CustomerSignResponseModel implements IResponseModel {
  @HiveField(0)
  final String customerSignatureImg;

  @HiveField(1)
  final String customerSignerName;

  @HiveField(2)
  final String customerSignLatitude;

  @HiveField(3)
  final String customerSignLongitude;

  @HiveField(4)
  final String date;

  CustomerSignResponseModel({
    required this.customerSignatureImg,
    required this.customerSignerName,
    required this.customerSignLatitude,
    required this.customerSignLongitude,
    required this.date,
  });

  factory CustomerSignResponseModel.fromJson(String json) {
    return CustomerSignResponseModel.fromMap(jsonDecode(json));
  }

  factory CustomerSignResponseModel.fromMap(Map<String, dynamic> map) {
    return CustomerSignResponseModel(
      customerSignatureImg: map['customerSignatureImg'],
      customerSignerName: map['customerSignerName'],
      customerSignLatitude: map['customerSignLatitude'],
      customerSignLongitude: map['customerSignLongitude'],
      date: map['date'],
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'customerSignatureImg': customerSignatureImg,
      'customerSignerName': customerSignerName,
      'customerSignLatitude': customerSignLatitude,
      'customerSignLongitude': customerSignLongitude,
      'date': date,
    };
  }
}
