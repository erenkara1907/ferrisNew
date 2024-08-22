// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobsResponseModelItemAdapter extends TypeAdapter<JobsResponseModelItem> {
  @override
  final int typeId = 104;

  @override
  JobsResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobsResponseModelItem(
      id: fields[0] as int,
      clientId: fields[1] as ClientResponseModel?,
      startAddressLabel: fields[53] as String?,
      endAddressLabel: fields[54] as String?,
      checkpoint1AddressLabel: fields[55] as String?,
      checkpoint2AddressLabel: fields[56] as String?,
      checkpoint3AddressLabel: fields[57] as String?,
      driverId: fields[2] as UserResponseModel?,
      vehicleId: fields[3] as VehicleModel?,
      movementTypeId: fields[4] as MovementTypeModel?,
      trackingStatusId: fields[5] as TrackingStatusModel?,
      regNumber: fields[6] as String?,
      customerName: fields[7] as String?,
      customerEmail: fields[8] as String?,
      customerContactNumber: fields[9] as String?,
      startAddress: fields[10] as String?,
      startAddressPostalCode: fields[11] as String?,
      endAddress: fields[12] as String?,
      endAddressPostalCode: fields[13] as String?,
      scheduleDate: fields[14] as String?,
      startDate: fields[15] as int?,
      endDate: fields[16] as int?,
      fuelChargeLevelDelivery: fields[18] as int?,
      fuelChargeLevelCollection: fields[17] as int?,
      customerFeedback: fields[19] as String?,
      status: fields[20] as int?,
      notes: fields[21] as String?,
      startAddressCordinates: fields[22] as LatLng?,
      endAddressCordinates: fields[23] as LatLng?,
      tiedInspections:
          (fields[25] as List?)?.cast<JobInspectionResponseModelItem>(),
      isDriverConfirm: fields[24] as bool?,
      stopsCount: fields[26] as int?,
      inspectionsCount: fields[27] as int?,
      predictedStartLocationTime: fields[28] as String?,
      predictedEndLocationTime: fields[29] as String?,
      expensesTotalCost: fields[30] as double?,
      checkpoint1Address: fields[31] as String?,
      checkpoint2Address: fields[32] as String?,
      checkpoint3Address: fields[33] as String?,
      checkpoint1AddressCordinates: fields[34] as LatLng?,
      checkpoint2AddressCordinates: fields[35] as LatLng?,
      checkpoint3AddressCordinates: fields[36] as LatLng?,
      isVisibleStartAddress: fields[37] as bool?,
      isVisibleCheckpoint1Address: fields[38] as bool?,
      isVisibleCheckpoint2Address: fields[39] as bool?,
      isVisibleCheckpoint3Address: fields[40] as bool?,
      isVisibleEndAddress: fields[41] as bool?,
      checkpoint1AddressPostalCode: fields[42] as String?,
      checkpoint2AddressPostalCode: fields[43] as String?,
      billableHoursStartTime: fields[45] as String?,
      billableHoursEndTime: fields[46] as String?,
      checkpoint3AddressPostalCode: fields[44] as String?,
      predictedCheckpoint1ArrivedTime: fields[47] as String?,
      predictedCheckpoint1DepartedTime: fields[48] as String?,
      predictedCheckpoint2ArrivedTime: fields[49] as String?,
      predictedCheckpoint2DepartedTime: fields[50] as String?,
      predictedCheckpoint3ArrivedTime: fields[51] as String?,
      predictedCheckpoint3DepartedTime: fields[52] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JobsResponseModelItem obj) {
    writer
      ..writeByte(58)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientId)
      ..writeByte(2)
      ..write(obj.driverId)
      ..writeByte(3)
      ..write(obj.vehicleId)
      ..writeByte(4)
      ..write(obj.movementTypeId)
      ..writeByte(5)
      ..write(obj.trackingStatusId)
      ..writeByte(6)
      ..write(obj.regNumber)
      ..writeByte(7)
      ..write(obj.customerName)
      ..writeByte(8)
      ..write(obj.customerEmail)
      ..writeByte(9)
      ..write(obj.customerContactNumber)
      ..writeByte(10)
      ..write(obj.startAddress)
      ..writeByte(11)
      ..write(obj.startAddressPostalCode)
      ..writeByte(12)
      ..write(obj.endAddress)
      ..writeByte(13)
      ..write(obj.endAddressPostalCode)
      ..writeByte(14)
      ..write(obj.scheduleDate)
      ..writeByte(15)
      ..write(obj.startDate)
      ..writeByte(16)
      ..write(obj.endDate)
      ..writeByte(17)
      ..write(obj.fuelChargeLevelCollection)
      ..writeByte(18)
      ..write(obj.fuelChargeLevelDelivery)
      ..writeByte(19)
      ..write(obj.customerFeedback)
      ..writeByte(20)
      ..write(obj.status)
      ..writeByte(21)
      ..write(obj.notes)
      ..writeByte(22)
      ..write(obj.startAddressCordinates)
      ..writeByte(23)
      ..write(obj.endAddressCordinates)
      ..writeByte(24)
      ..write(obj.isDriverConfirm)
      ..writeByte(25)
      ..write(obj.tiedInspections)
      ..writeByte(26)
      ..write(obj.stopsCount)
      ..writeByte(27)
      ..write(obj.inspectionsCount)
      ..writeByte(28)
      ..write(obj.predictedStartLocationTime)
      ..writeByte(29)
      ..write(obj.predictedEndLocationTime)
      ..writeByte(30)
      ..write(obj.expensesTotalCost)
      ..writeByte(31)
      ..write(obj.checkpoint1Address)
      ..writeByte(32)
      ..write(obj.checkpoint2Address)
      ..writeByte(33)
      ..write(obj.checkpoint3Address)
      ..writeByte(34)
      ..write(obj.checkpoint1AddressCordinates)
      ..writeByte(35)
      ..write(obj.checkpoint2AddressCordinates)
      ..writeByte(36)
      ..write(obj.checkpoint3AddressCordinates)
      ..writeByte(37)
      ..write(obj.isVisibleStartAddress)
      ..writeByte(38)
      ..write(obj.isVisibleCheckpoint1Address)
      ..writeByte(39)
      ..write(obj.isVisibleCheckpoint2Address)
      ..writeByte(40)
      ..write(obj.isVisibleCheckpoint3Address)
      ..writeByte(41)
      ..write(obj.isVisibleEndAddress)
      ..writeByte(42)
      ..write(obj.checkpoint1AddressPostalCode)
      ..writeByte(43)
      ..write(obj.checkpoint2AddressPostalCode)
      ..writeByte(44)
      ..write(obj.checkpoint3AddressPostalCode)
      ..writeByte(45)
      ..write(obj.billableHoursStartTime)
      ..writeByte(46)
      ..write(obj.billableHoursEndTime)
      ..writeByte(47)
      ..write(obj.predictedCheckpoint1ArrivedTime)
      ..writeByte(48)
      ..write(obj.predictedCheckpoint1DepartedTime)
      ..writeByte(49)
      ..write(obj.predictedCheckpoint2ArrivedTime)
      ..writeByte(50)
      ..write(obj.predictedCheckpoint2DepartedTime)
      ..writeByte(51)
      ..write(obj.predictedCheckpoint3ArrivedTime)
      ..writeByte(52)
      ..write(obj.predictedCheckpoint3DepartedTime)
      ..writeByte(53)
      ..write(obj.startAddressLabel)
      ..writeByte(54)
      ..write(obj.endAddressLabel)
      ..writeByte(55)
      ..write(obj.checkpoint1AddressLabel)
      ..writeByte(56)
      ..write(obj.checkpoint2AddressLabel)
      ..writeByte(57)
      ..write(obj.checkpoint3AddressLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobsResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClientResponseModelAdapter extends TypeAdapter<ClientResponseModel> {
  @override
  final int typeId = 111;

  @override
  ClientResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientResponseModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      address1: fields[2] as String?,
      postalCode: fields[3] as String?,
      locality: fields[4] as String?,
      country: fields[5] as String?,
      contactEmail: fields[6] as String?,
      contactNumber: fields[7] as String?,
      viewCosts: fields[8] as int?,
      latestInvoiceNumber: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientResponseModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address1)
      ..writeByte(3)
      ..write(obj.postalCode)
      ..writeByte(4)
      ..write(obj.locality)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.contactEmail)
      ..writeByte(7)
      ..write(obj.contactNumber)
      ..writeByte(8)
      ..write(obj.viewCosts)
      ..writeByte(9)
      ..write(obj.latestInvoiceNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 119;

  @override
  LatLng read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatLng(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLngAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
