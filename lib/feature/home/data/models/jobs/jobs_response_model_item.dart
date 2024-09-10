import 'dart:convert';

import 'package:ferrisfwt/product/manager/utils/util/app_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/movement_type_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/tracking_status_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/vehicle_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:hive/hive.dart';

part 'jobs_response_model_item.g.dart';

@HiveType(typeId: 104)
class JobsResponseModelItem implements IResponseModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final ClientResponseModel? clientId;
  @HiveField(2)
  final UserResponseModel? driverId;
  @HiveField(3)
  final VehicleModel? vehicleId;
  @HiveField(4)
  final MovementTypeModel? movementTypeId;
  @HiveField(5)
  final TrackingStatusModel? trackingStatusId;
  @HiveField(6)
  final String? regNumber;
  @HiveField(7)
  final String? customerName;
  @HiveField(8)
  final String? customerEmail;
  @HiveField(9)
  final String? customerContactNumber;
  @HiveField(10)
  final String? startAddress;
  @HiveField(11)
  final String? startAddressPostalCode;
  @HiveField(12)
  final String? endAddress;
  @HiveField(13)
  final String? endAddressPostalCode;
  @HiveField(14)
  final String? scheduleDate;
  @HiveField(15)
  final int? startDate;
  @HiveField(16)
  final int? endDate;
  @HiveField(17)
  final int? fuelChargeLevelCollection;
  @HiveField(18)
  final int? fuelChargeLevelDelivery;
  @HiveField(19)
  final String? customerFeedback;
  @HiveField(20)
  late final int? status;
  @HiveField(21)
  final String? notes;
  @HiveField(22)
  final LatLng? startAddressCordinates;
  @HiveField(23)
  final LatLng? endAddressCordinates;
  @HiveField(24)
  final bool? isDriverConfirm;
  @HiveField(25)
  final List<JobInspectionResponseModelItem>? tiedInspections;
  @HiveField(26)
  final int? stopsCount;
  @HiveField(27)
  final int? inspectionsCount;
  @HiveField(28)
  final String? predictedStartLocationTime;
  @HiveField(29)
  final String? predictedEndLocationTime;
  @HiveField(30)
  final double? expensesTotalCost;
  @HiveField(31)
  final String? checkpoint1Address;
  @HiveField(32)
  final String? checkpoint2Address;
  @HiveField(33)
  final String? checkpoint3Address;
  @HiveField(34)
  final LatLng? checkpoint1AddressCordinates;
  @HiveField(35)
  final LatLng? checkpoint2AddressCordinates;
  @HiveField(36)
  final LatLng? checkpoint3AddressCordinates;
  @HiveField(37)
  final bool? isVisibleStartAddress;
  @HiveField(38)
  final bool? isVisibleCheckpoint1Address;
  @HiveField(39)
  final bool? isVisibleCheckpoint2Address;
  @HiveField(40)
  final bool? isVisibleCheckpoint3Address;
  @HiveField(41)
  final bool? isVisibleEndAddress;
  @HiveField(42)
  final String? checkpoint1AddressPostalCode;
  @HiveField(43)
  final String? checkpoint2AddressPostalCode;
  @HiveField(44)
  final String? checkpoint3AddressPostalCode;
  @HiveField(45)
  final String? billableHoursStartTime;
  @HiveField(46)
  final String? billableHoursEndTime;
  @HiveField(47)
  final String? predictedCheckpoint1ArrivedTime;
  @HiveField(48)
  final String? predictedCheckpoint1DepartedTime;
  @HiveField(49)
  final String? predictedCheckpoint2ArrivedTime;
  @HiveField(50)
  final String? predictedCheckpoint2DepartedTime;
  @HiveField(51)
  final String? predictedCheckpoint3ArrivedTime;
  @HiveField(52)
  final String? predictedCheckpoint3DepartedTime;
  @HiveField(53)
  final String? startAddressLabel;
  @HiveField(54)
  final String? endAddressLabel;
  @HiveField(55)
  final String? checkpoint1AddressLabel;
  @HiveField(56)
  final String? checkpoint2AddressLabel;
  @HiveField(57)
  final String? checkpoint3AddressLabel;

  JobsResponseModelItem({
    required this.id,
    this.clientId,
    this.startAddressLabel,
    this.endAddressLabel,
    this.checkpoint1AddressLabel,
    this.checkpoint2AddressLabel,
    this.checkpoint3AddressLabel,
    this.driverId,
    this.vehicleId,
    this.movementTypeId,
    this.trackingStatusId,
    this.regNumber,
    this.customerName,
    this.customerEmail,
    this.customerContactNumber,
    this.startAddress,
    this.startAddressPostalCode,
    this.endAddress,
    this.endAddressPostalCode,
    this.scheduleDate,
    this.startDate,
    this.endDate,
    this.fuelChargeLevelDelivery,
    this.fuelChargeLevelCollection,
    this.customerFeedback,
    this.status,
    this.notes,
    this.startAddressCordinates,
    this.endAddressCordinates,
    this.tiedInspections,
    this.isDriverConfirm,
    this.stopsCount,
    this.inspectionsCount,
    this.predictedStartLocationTime,
    this.predictedEndLocationTime,
    this.expensesTotalCost,
    this.checkpoint1Address,
    this.checkpoint2Address,
    this.checkpoint3Address,
    this.checkpoint1AddressCordinates,
    this.checkpoint2AddressCordinates,
    this.checkpoint3AddressCordinates,
    this.isVisibleStartAddress,
    this.isVisibleCheckpoint1Address,
    this.isVisibleCheckpoint2Address,
    this.isVisibleCheckpoint3Address,
    this.isVisibleEndAddress,
    this.checkpoint1AddressPostalCode,
    this.checkpoint2AddressPostalCode,
    this.billableHoursStartTime,
    this.billableHoursEndTime,
    this.checkpoint3AddressPostalCode,
    this.predictedCheckpoint1ArrivedTime,
    this.predictedCheckpoint1DepartedTime,
    this.predictedCheckpoint2ArrivedTime,
    this.predictedCheckpoint2DepartedTime,
    this.predictedCheckpoint3ArrivedTime,
    this.predictedCheckpoint3DepartedTime,
  });

  factory JobsResponseModelItem.fromJson(String json) {
    return JobsResponseModelItem.fromMap(jsonDecode(json));
  }

  factory JobsResponseModelItem.fromMap(Map<String, dynamic> map) {
    final result = JobsResponseModelItem(
      id: map['id'] as int,
      clientId: map['subClientId'] == null
          ? null
          : ClientResponseModel.fromMap(
              map['subClientId'] as Map<String, dynamic>),
      driverId: map['driverId'] == null
          ? null
          : UserResponseModel.fromMap(map['driverId'] as Map<String, dynamic>),
      vehicleId: map['vehicleId'] == null
          ? null
          : VehicleModel.fromMap(map['vehicleId'] as Map<String, dynamic>),
      movementTypeId: map['movementTypeId'] == null ||
              map['movementTypeId'] is! Map<String, dynamic>
          ? null
          : MovementTypeModel.fromMap(
              map['movementTypeId'] as Map<String, dynamic>),
      trackingStatusId:
          map['trackingStatusId'] == null || map['trackingStatusId'] is int
              ? null
              : TrackingStatusModel.fromMap(map['trackingStatusId']),
      regNumber: map['regNumber'] as String?,
      startAddressLabel: map['startAddressLabel'] as String?,
      endAddressLabel: map['endAddressLabel'] as String?,
      checkpoint1AddressLabel: map['checkpoint1AddressLabel'] as String?,
      checkpoint2AddressLabel: map['checkpoint2AddressLabel'] as String?,
      checkpoint3AddressLabel: map['checkpoint3AddressLabel'] as String?,
      customerName: map['customerName'] as String?,
      customerEmail: map['customerEmail'] as String?,
      customerContactNumber: map['customerContactNumber'] as String?,
      startAddress: map['startAddress'] as String?,
      checkpoint1Address: map['checkpoint1Address'] as String?,
      checkpoint2Address: map['checkpoint2Address'] as String?,
      checkpoint3Address: map['checkpoint3Address'] as String?,
      isVisibleStartAddress: map['isVisibleStartAddress'] as bool?,
      isVisibleCheckpoint1Address: map['isVisibleCheckpoint1Address'] as bool?,
      isVisibleCheckpoint2Address: map['isVisibleCheckpoint2Address'] as bool?,
      isVisibleCheckpoint3Address: map['isVisibleCheckpoint3Address'] as bool?,
      checkpoint1AddressPostalCode:
          map['checkpoint1AddressPostalCode'] as String?,
      checkpoint2AddressPostalCode:
          map['checkpoint2AddressPostalCode'] as String?,
      checkpoint3AddressPostalCode:
          map['checkpoint3AddressPostalCode'] as String?,
      isVisibleEndAddress: map['isVisibleEndAddress'] as bool?,
      startAddressPostalCode: map['startAddressPostalCode'] as String?,
      endAddress: map['endAddress'] as String?,
      endAddressPostalCode: map['endAddressPostalCode'] as String?,
      scheduleDate: map['scheduleDate'] as String?,
      startDate: map['startDate'] as int?,
      endDate: map['endDate'] as int?,
      fuelChargeLevelCollection: map['fuelChargeLevelCollection'] as int?,
      fuelChargeLevelDelivery: map['fuelChargeLevelDelivery'] as int?,
      customerFeedback: map['customerFeedback'] as String?,
      status: map['status'] as int?,
      notes: map['notes'] as String?,
      startAddressCordinates: map['startAddressCordinates'] != null
          ? LatLng.fromMap(map['startAddressCordinates'])
          : null,
      checkpoint1AddressCordinates: map['checkpoint1AddressCordinates'] != null
          ? LatLng.fromMap(map['checkpoint1AddressCordinates'])
          : null,
      checkpoint2AddressCordinates: map['checkpoint2AddressCordinates'] != null
          ? LatLng.fromMap(map['checkpoint2AddressCordinates'])
          : null,
      checkpoint3AddressCordinates: map['checkpoint3AddressCordinates'] != null
          ? LatLng.fromMap(map['checkpoint3AddressCordinates'])
          : null,
      endAddressCordinates: map['endAddressCordinates'] != null
          ? LatLng.fromMap(map['endAddressCordinates'])
          : null,
      isDriverConfirm: map['isDriverConfirm'] as bool?,
      tiedInspections: map['tiedInspections'] == null
          ? null
          : (map['tiedInspections'] as List<dynamic>)
              .map((e) => JobInspectionResponseModelItem.fromMap(
                    e as Map<String, dynamic>,
                  ))
              .toList(),
      stopsCount: map['stopsCount'] as int?,
      inspectionsCount: map['inspectionsCount'] as int?,
      predictedStartLocationTime:
          map['predictedStartLocationDepartedTime'] as String?,
      predictedEndLocationTime:
          map['predictedEndLocationArrivedTime'] as String?,
      billableHoursStartTime: map['billableHoursStartTime'] as String?,
      billableHoursEndTime: map['billableHoursEndTime'] as String?,
      predictedCheckpoint1ArrivedTime:
          map['predictedCheckpoint1ArrivedTime'] as String?,
      predictedCheckpoint1DepartedTime:
          map['predictedCheckpoint1DepartedTime'] as String?,
      predictedCheckpoint2ArrivedTime:
          map['predictedCheckpoint2ArrivedTime'] as String?,
      predictedCheckpoint2DepartedTime:
          map['predictedCheckpoint2DepartedTime'] as String?,
      predictedCheckpoint3ArrivedTime:
          map['predictedCheckpoint3ArrivedTime'] as String?,
      predictedCheckpoint3DepartedTime:
          map['predictedCheckpoint3DepartedTime'] as String?,
      expensesTotalCost: map['expensesTotalCost'] is int
          ? (map['expensesTotalCost'] as int).toDouble()
          : map['expensesTotalCost'] as double?,
    );
    return result;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId?.toMap(),
      'driverId': driverId,
      'vehicleId': vehicleId?.toMap(),
      'movementTypeId': movementTypeId?.toMap(),
      'trackingStatusId': trackingStatusId?.toMap(),
      'regNumber': regNumber,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerContactNumber': customerContactNumber,
      'startAddress': startAddress,
      'startAddressPostalCode': startAddressPostalCode,
      'endAddress': endAddress,
      'endAddressPostalCode': endAddressPostalCode,
      'scheduleDate': scheduleDate,
      'startDate': startDate,
      'endDate': endDate,
      'fuelChargeLevelCollection': fuelChargeLevelCollection,
      'fuelChargeLevelDelivery': fuelChargeLevelDelivery,
      'customerFeedback': customerFeedback,
      'status': status,
      'notes': notes,
      'startAddressCordinates': startAddressCordinates?.toMap(),
      'endAddressCordinates': endAddressCordinates?.toMap(),
      'isDriverConfirm': isDriverConfirm,
      'tiedInspections': tiedInspections?.map((e) => e.toMap()).toList(),
      'stopsCount': stopsCount,
      'inspectionsCount': inspectionsCount,
      'predictedStartLocationTime': predictedStartLocationTime,
      'predictedEndLocationTime': predictedEndLocationTime,
      'expensesTotalCost': expensesTotalCost,
    };
  }

  /// returns a new instance of [JobsResponseModelItem] with the given
  /// inspections. If the given inspections is null, it will remove the
  /// inspections.
  JobsResponseModelItem copyWithInspections(
    List<JobInspectionResponseModelItem>? inspections,
  ) {
    final newMap = {...toMap()};
    newMap['tiedInspections'] = inspections?.map((e) => e.toMap()).toList();
    return JobsResponseModelItem.fromMap(newMap);
  }

  /// replaces the inspection with the given inspections id. If the inspection
  /// is not found, it will throw an exception.
  JobsResponseModelItem copyWithAReplacedInspection(
    JobInspectionResponseModelItem inspection,
  ) {
    if (tiedInspections == null) throw Exception('tiedInspections is null');
    final newMap = {...toMap()};
    final index = tiedInspections!.indexWhere((e) => e.id == inspection.id);
    if (index == -1) throw Exception('inspection not found');
    tiedInspections![index] = inspection;
    newMap['tiedInspections'] = tiedInspections!.map((e) => e.toMap()).toList();
    return JobsResponseModelItem.fromMap(newMap);
  }

  JobsResponseModelItem copyWithConfirmed(bool confirmed) {
    final newMap = {...toMap()};
    newMap['isDriverConfirm'] = confirmed;
    return JobsResponseModelItem.fromMap(newMap);
  }

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (other is JobsResponseModelItem) {
      return other.id == id;
    }
    return false;
  }

  String? get date {
    final DateTime? jobDateTime = DateTime.tryParse('$scheduleDate');
    if (jobDateTime == null) return null;
    return jobDateTime.toBeautifulFormat(includeTime: false);
  }

  JobStatusEnum get jobStatus {
    DateTime now = DateTime.now();
    DateTime? jobDateTime;
    if (scheduleDate != null) {
      jobDateTime = DateTime.parse('$scheduleDate');
    }
    switch (status) {
      case 0:
        if (jobDateTime == null) return JobStatusEnum.upcoming;
        if (now.compareTo(jobDateTime) < 0) {
          return JobStatusEnum.upcoming;
        } else {
          return JobStatusEnum.departNow;
        }
      case 1:
        return JobStatusEnum.started;
      case 2:
        return JobStatusEnum.completed;
    }
    return JobStatusEnum.unknown;
  }

  @override
  int get hashCode => id.hashCode;
}

enum JobStatusEnum {
  upcoming,
  departNow,
  started,
  completed,
  unknown,
}

@HiveType(typeId: 111)
class ClientResponseModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? address1;
  @HiveField(3)
  String? postalCode;
  @HiveField(4)
  String? locality;
  @HiveField(5)
  String? country;
  @HiveField(6)
  String? contactEmail;
  @HiveField(7)
  String? contactNumber;
  @HiveField(8)
  int? viewCosts;
  @HiveField(9)
  String? latestInvoiceNumber;

  ClientResponseModel({
    this.id,
    this.name,
    this.address1,
    this.postalCode,
    this.locality,
    this.country,
    this.contactEmail,
    this.contactNumber,
    this.viewCosts,
    this.latestInvoiceNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address1': address1,
      'postalCode': postalCode,
      'locality': locality,
      'country': country,
      'contactEmail': contactEmail,
      'contactNumber': contactNumber,
      'viewCosts': viewCosts,
      'latestInvoiceNumber': latestInvoiceNumber,
    };
  }

  factory ClientResponseModel.fromMap(Map<String, dynamic> json) {
    return ClientResponseModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address1: json['address1'] as String?,
      postalCode: json['postalCode'] as String?,
      locality: json['locality'] as String?,
      country: json['country'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactNumber: json['contactNumber'] as String?,
      viewCosts: json['viewCosts'] as int?,
      latestInvoiceNumber: json['latestInvoiceNumber'] as String?,
    );
  }

  @override
  String toString() => '$runtimeType(${toMap()})';
}

@HiveType(typeId: 119)
final class LatLng extends IResponseModel {
  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;

  LatLng({
    required this.latitude,
    required this.longitude,
  });

  factory LatLng.fromMap(Map<String, dynamic> map) {
    return LatLng(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
