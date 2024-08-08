import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/gradle_item_model.dart';

import 'package:ferrisfwt/product/manager/utils/util/app_extensions.dart';

import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:hive/hive.dart';

import 'job_inspection_type.dart';

part 'job_inspection_response_model_item.g.dart';

@HiveType(typeId: 197)
class JobInspectionResponseModelItem extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final JobsResponseModelItem? jobId;
  @HiveField(2)
  final JobInspectionType? typeId;
  @HiveField(3)
  final int? reportSigned;
  @HiveField(4)
  final int? conditionImagesAdded;
  @HiveField(5)
  final String? reportNumber;
  @HiveField(6)
  final int? paymentMade;
  @HiveField(7)
  final int? checklistComplete;
  @HiveField(8)
  final JobInspectionAbortTypeItem? abortType;
  @HiveField(9)
  final String? date;
  @HiveField(10)
  final String? time;
  @HiveField(11)
  final double? odoReading;
  @HiveField(12)
  final int? fuelLevel;
  @HiveField(13)
  final String? paymentMethod;
  @HiveField(14)
  final String? customerLocality;
  @HiveField(15)
  final String? customerState;
  @HiveField(16)
  final String? customerCountry;
  @HiveField(17)
  final String? notes;
  @HiveField(18)
  final String? inspectorSignerName;
  @HiveField(19)
  final String? inspectorSignature;
  @HiveField(20)
  final String? inspectorSignedDate;
  @HiveField(21)
  final String? inspectorSignedLatitude;
  @HiveField(22)
  final String? inspectorSignedLongitude;
  @HiveField(23)
  final String? customerSignerName;
  @HiveField(24)
  final String? customerSignature;
  @HiveField(25)
  final String? customerSignedDate;
  @HiveField(26)
  final String? customerSignedLatitude;
  @HiveField(27)
  final String? customerSignedLongitude;
  @HiveField(28)
  final GradeId? gradleItem;

  const JobInspectionResponseModelItem({
    required this.id,
    this.jobId,
    this.gradleItem,
    this.typeId,
    this.reportSigned,
    this.conditionImagesAdded,
    this.reportNumber,
    this.paymentMade,
    this.checklistComplete,
    this.abortType,
    this.date,
    this.time,
    this.odoReading,
    this.fuelLevel,
    this.paymentMethod,
    this.customerLocality,
    this.customerState,
    this.customerCountry,
    this.notes,
    this.inspectorSignerName,
    this.inspectorSignature,
    this.inspectorSignedDate,
    this.inspectorSignedLatitude,
    this.inspectorSignedLongitude,
    this.customerSignerName,
    this.customerSignature,
    this.customerSignedDate,
    this.customerSignedLatitude,
    this.customerSignedLongitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId?.toMap(),
      'gradeId': gradleItem?.toMap(),
      'typeId': typeId?.toMap(),
      'reportSigned': reportSigned,
      'conditionImagesAdded': conditionImagesAdded,
      'reportNumber': reportNumber,
      'paymentMade': paymentMade,
      'checklistComplete': checklistComplete,
      'abortType': abortType?.toMap(),
      'date': date,
      'time': time,
      'odoReading': odoReading,
      'fuelLevel': fuelLevel,
      'paymentMethod': paymentMethod,
      'customerLocality': customerLocality,
      'customerState': customerState,
      'customerCountry': customerCountry,
      'notes': notes,
      'inspectorSignerName': inspectorSignerName,
      'inspectorSignature': inspectorSignature,
      'inspectorSignedDate': inspectorSignedDate,
      'inspectorSignedLatitude': inspectorSignedLatitude,
      'inspectorSignedLongitude': inspectorSignedLongitude,
      'customerSignerName': customerSignerName,
      'customerSignature': customerSignature,
      'customerSignedDate': customerSignedDate,
      'customerSignedLatitude': customerSignedLatitude,
      'customerSignedLongitude': customerSignedLongitude,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory JobInspectionResponseModelItem.fromMap(Map<String, dynamic> map) {
    return JobInspectionResponseModelItem(
      id: map['id'] as int?,
      jobId: map['jobId'] == null
          ? null
          : JobsResponseModelItem.fromMap(map['jobId'] as Map<String, dynamic>),
      gradleItem: map['gradeId'] == null
          ? null
          : GradeId.fromMap(map['gradeId'] as Map<String, dynamic>),
      typeId: map['typeId'] == null
          ? null
          : JobInspectionType.fromMap(map['typeId'] as Map<String, dynamic>),
      reportSigned: map['reportSigned'],
      conditionImagesAdded: map['conditionImagesAdded'],
      reportNumber: map['reportNumber'],
      paymentMade: map['paymentMade'],
      checklistComplete: map['checklistComplete'],
      abortType: map['abortType'] == null
          ? null
          : JobInspectionAbortTypeItem.fromMap(
              map['abortType'] as Map<String, dynamic>),
      date: map['date'],
      time: map['time'],
      odoReading: (map['odoReading'] as num?)?.toDouble(),
      fuelLevel: map['fuelLevel'],
      paymentMethod: map['paymentMethod'],
      customerLocality: map['customerLocality'],
      customerState: map['customerState'],
      customerCountry: map['customerCountry'],
      notes: map['notes'],
      inspectorSignerName: map['inspectorSignerName'],
      inspectorSignature: map['inspectorSignature'],
      inspectorSignedDate: map['inspectorSignedDate'],
      inspectorSignedLatitude: map['inspectorSignedLatitude'],
      inspectorSignedLongitude: map['inspectorSignedLongitude'],
      customerSignerName: map['customerSignerName'],
      customerSignature: map['customerSignature'],
      customerSignedDate: map['customerSignedDate'],
      customerSignedLatitude: map['customerSignedLatitude'],
      customerSignedLongitude: map['customerSignedLongitude'],
    );
  }

  factory JobInspectionResponseModelItem.fromJson(String json) {
    return JobInspectionResponseModelItem.fromMap(jsonDecode(json));
  }

  String? get dateAndTime {
    final DateTime? jobDateTime = DateTime.tryParse('$date $time');
    if (jobDateTime == null) return null;
    return jobDateTime.toBeautifulFormat(includeTime: true);
  }

  @override
  List<Object?> get props => [
        id,
        jobId,
        gradleItem,
        typeId,
        reportSigned,
        conditionImagesAdded,
        reportNumber,
        paymentMade,
        checklistComplete,
        abortType,
        date,
        time,
        odoReading,
        fuelLevel,
        paymentMethod,
        customerLocality,
        customerState,
        customerCountry,
        notes,
        inspectorSignerName,
        inspectorSignature,
        inspectorSignedDate,
        inspectorSignedLatitude,
        inspectorSignedLongitude,
        customerSignerName,
        customerSignature,
        customerSignedDate,
        customerSignedLatitude,
        customerSignedLongitude,
      ];

  JobInspectionResponseModelItem copyWith({
    int? id,
    JobsResponseModelItem? jobId,
    GradeId? gradleItem,
    JobInspectionType? typeId,
    int? reportSigned,
    int? conditionImagesAdded,
    String? reportNumber,
    int? paymentMade,
    int? checklistComplete,
    JobInspectionAbortTypeItem? abortType,
    String? date,
    String? time,
    double? odoReading,
    int? fuelLevel,
    String? paymentMethod,
    String? customerLocality,
    String? customerState,
    String? customerCountry,
    String? notes,
    String? inspectorSignerName,
    String? inspectorSignature,
    String? inspectorSignedDate,
    String? inspectorSignedLatitude,
    String? inspectorSignedLongitude,
    String? customerSignerName,
    String? customerSignature,
    String? customerSignedDate,
    String? customerSignedLatitude,
    String? customerSignedLongitude,
  }) {
    return JobInspectionResponseModelItem(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      gradleItem: gradleItem ?? this.gradleItem,
      typeId: typeId ?? this.typeId,
      reportSigned: reportSigned ?? this.reportSigned,
      conditionImagesAdded: conditionImagesAdded ?? this.conditionImagesAdded,
      reportNumber: reportNumber ?? this.reportNumber,
      paymentMade: paymentMade ?? this.paymentMade,
      checklistComplete: checklistComplete ?? this.checklistComplete,
      abortType: abortType ?? this.abortType,
      date: date ?? this.date,
      time: time ?? this.time,
      odoReading: odoReading ?? this.odoReading,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerLocality: customerLocality ?? this.customerLocality,
      customerState: customerState ?? this.customerState,
      customerCountry: customerCountry ?? this.customerCountry,
      notes: notes ?? this.notes,
      inspectorSignerName: inspectorSignerName ?? this.inspectorSignerName,
      inspectorSignature: inspectorSignature ?? this.inspectorSignature,
      inspectorSignedDate: inspectorSignedDate ?? this.inspectorSignedDate,
      inspectorSignedLatitude:
          inspectorSignedLatitude ?? this.inspectorSignedLatitude,
      inspectorSignedLongitude:
          inspectorSignedLongitude ?? this.inspectorSignedLongitude,
      customerSignerName: customerSignerName ?? this.customerSignerName,
      customerSignature: customerSignature ?? this.customerSignature,
      customerSignedDate: customerSignedDate ?? this.customerSignedDate,
      customerSignedLatitude:
          customerSignedLatitude ?? this.customerSignedLatitude,
      customerSignedLongitude:
          customerSignedLongitude ?? this.customerSignedLongitude,
    );
  }
}
