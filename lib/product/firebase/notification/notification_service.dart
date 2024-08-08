import 'package:ferrisfwt/product/manager/utils/util/app_extensions.dart';

class JobAssignmentAnnouncementData {
  final int? jobId;
  final String? regNumber;
  final String? scheduleDate;
  final String? movementTypeName;
  final String? startAddress;
  final String? startAddressPostalCode;
  final String? endAddress;
  final String? endAddressPostalCode;

  JobAssignmentAnnouncementData({
    required this.jobId,
    required this.regNumber,
    required this.scheduleDate,
    required this.movementTypeName,
    required this.startAddress,
    required this.startAddressPostalCode,
    required this.endAddress,
    required this.endAddressPostalCode,
  });

  factory JobAssignmentAnnouncementData.fromMap(Map<String, dynamic> map) {
    return JobAssignmentAnnouncementData(
      jobId: map['jobId'] is int ? map['jobId'] : int.parse(map['jobId']),
      regNumber: map['regNumber'],
      scheduleDate: map['scheduleDate'],
      movementTypeName: map['movementTypeName'],
      startAddress: map['startAddress'],
      startAddressPostalCode: map['startAddressPostalCode'],
      endAddress: map['endAddress'],
      endAddressPostalCode: map['endAddressPostalCode'],
    );
  }

  String? get fromAddressFormatted {
    if (startAddress == null) return null;
    return startAddress! +
        (startAddressPostalCode == null ? '' : ' ${startAddressPostalCode!}');
  }

  String? get toAddressFormatted {
    if (endAddress == null) return null;
    return endAddress! +
        (endAddressPostalCode == null ? '' : ' ${endAddressPostalCode!}');
  }

  String? get dateFormatted {
    if (scheduleDate == null) return null;
    final DateTime dateTime = DateTime.parse(scheduleDate!);
    
    return dateTime.toDateFormat;
  }
}
