import 'package:equatable/equatable.dart';

import 'damage_response_model.dart';

class DamageUpdateResponseModel extends Equatable {
  final DamageResponseModel oldDamage;
  final DamageResponseModel newDamage;

  DamageUpdateResponseModel({
    required this.oldDamage,
    required this.newDamage,
  });

  factory DamageUpdateResponseModel.fromMap(Map<String, dynamic> map) {
    return DamageUpdateResponseModel(
      oldDamage: DamageResponseModel.fromMap(map['old']),
      newDamage: DamageResponseModel.fromMap(map['new']),
    );
  }

  @override
  List<Object?> get props => [oldDamage, newDamage];
}
