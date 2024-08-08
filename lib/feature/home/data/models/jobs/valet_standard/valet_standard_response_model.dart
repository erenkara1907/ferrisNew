import 'dart:convert';

import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';

class ValetStandardResponseModel implements IResponseModel {
  final List<ValetStandardResponseModelItem>? data;

  ValetStandardResponseModel({
    this.data,
  });

  factory ValetStandardResponseModel.fromJson(String json) {
    return ValetStandardResponseModel.fromMapList(jsonDecode(json));
  }

  factory ValetStandardResponseModel.fromMapList(List<dynamic> mapList) {
    return ValetStandardResponseModel(
      data: mapList
          .map((map) => ValetStandardResponseModelItem.fromMap(map))
          .toList(),
    );
  }
}
