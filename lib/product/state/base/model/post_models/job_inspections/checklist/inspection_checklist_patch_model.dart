import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

class InspectionChecklistPatchModel extends INetworkSentDataModel {
  final int? inflatorKit;
  final int? evCable;
  final int? jack;
  final int? spareWheel;
  final int? gelCompressorKit;
  final int? thirteenAmpEvChargingCable; // different name in the api
  final int? hvChargingCable;
  final int? spareKey;
  final int? masterKey;

  InspectionChecklistPatchModel({
    this.inflatorKit,
    this.evCable,
    this.jack,
    this.spareWheel,
    this.gelCompressorKit,
    this.thirteenAmpEvChargingCable,
    this.hvChargingCable,
    this.spareKey,
    this.masterKey,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (inflatorKit != null) 'inflatorKit': inflatorKit,
      if (evCable != null) 'evCable': evCable,
      if (jack != null) 'jack': jack,
      if (spareWheel != null) 'spareWheel': spareWheel,
      if (gelCompressorKit != null) 'gelCompressorKit': gelCompressorKit,
      if (thirteenAmpEvChargingCable != null)
        '13AmpEvChargingCable': thirteenAmpEvChargingCable,
      if (hvChargingCable != null) 'hvChargingCable': hvChargingCable,
      if (spareKey != null) 'spareKey': spareKey,
      if (masterKey != null) 'masterKey': masterKey,
    };
  }
}
