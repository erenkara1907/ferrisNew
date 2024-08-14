// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_inspection_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobInspectionResponseModelItemAdapter
    extends TypeAdapter<JobInspectionResponseModelItem> {
  @override
  final int typeId = 197;

  @override
  JobInspectionResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobInspectionResponseModelItem(
      id: fields[0] as int?,
      jobId: fields[1] as JobsResponseModelItem?,
      gradleItem: fields[28] as GradeId?,
      typeId: fields[2] as JobInspectionType?,
      reportSigned: fields[3] as dynamic,
      conditionImagesAdded: fields[4] as int?,
      reportNumber: fields[5] as String?,
      paymentMade: fields[6] as dynamic,
      checklistComplete: fields[7] as dynamic,
      abortType: fields[8] as JobInspectionAbortTypeItem?,
      date: fields[9] as String?,
      time: fields[10] as String?,
      odoReading: fields[11] as double?,
      fuelLevel: fields[12] as int?,
      paymentMethod: fields[13] as String?,
      customerLocality: fields[14] as String?,
      customerState: fields[15] as String?,
      customerCountry: fields[16] as String?,
      notes: fields[17] as String?,
      inspectorSignerName: fields[18] as String?,
      inspectorSignature: fields[19] as String?,
      inspectorSignedDate: fields[20] as String?,
      inspectorSignedLatitude: fields[21] as String?,
      inspectorSignedLongitude: fields[22] as String?,
      customerSignerName: fields[23] as String?,
      customerSignature: fields[24] as String?,
      customerSignedDate: fields[25] as String?,
      customerSignedLatitude: fields[26] as String?,
      customerSignedLongitude: fields[27] as String?,
      damageStandards: (fields[29] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, JobInspectionResponseModelItem obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.typeId)
      ..writeByte(3)
      ..write(obj.reportSigned)
      ..writeByte(4)
      ..write(obj.conditionImagesAdded)
      ..writeByte(5)
      ..write(obj.reportNumber)
      ..writeByte(6)
      ..write(obj.paymentMade)
      ..writeByte(7)
      ..write(obj.checklistComplete)
      ..writeByte(8)
      ..write(obj.abortType)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.time)
      ..writeByte(11)
      ..write(obj.odoReading)
      ..writeByte(12)
      ..write(obj.fuelLevel)
      ..writeByte(13)
      ..write(obj.paymentMethod)
      ..writeByte(14)
      ..write(obj.customerLocality)
      ..writeByte(15)
      ..write(obj.customerState)
      ..writeByte(16)
      ..write(obj.customerCountry)
      ..writeByte(17)
      ..write(obj.notes)
      ..writeByte(18)
      ..write(obj.inspectorSignerName)
      ..writeByte(19)
      ..write(obj.inspectorSignature)
      ..writeByte(20)
      ..write(obj.inspectorSignedDate)
      ..writeByte(21)
      ..write(obj.inspectorSignedLatitude)
      ..writeByte(22)
      ..write(obj.inspectorSignedLongitude)
      ..writeByte(23)
      ..write(obj.customerSignerName)
      ..writeByte(24)
      ..write(obj.customerSignature)
      ..writeByte(25)
      ..write(obj.customerSignedDate)
      ..writeByte(26)
      ..write(obj.customerSignedLatitude)
      ..writeByte(27)
      ..write(obj.customerSignedLongitude)
      ..writeByte(28)
      ..write(obj.gradleItem)
      ..writeByte(29)
      ..write(obj.damageStandards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobInspectionResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
