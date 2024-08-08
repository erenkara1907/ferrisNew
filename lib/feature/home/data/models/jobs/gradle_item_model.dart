import 'package:hive/hive.dart';

@HiveType(typeId: 105)
// class GradleItem {
//   @HiveField(0)
//   GradeId? gradeId;

//   GradleItem({this.gradeId});

//   GradleItem.fromMap(Map<String, dynamic> json) {
//     print("GRADE ITEM ${json['gradeId']}");
//     gradeId =
//         json['gradeId'] != null ? GradeId.fromJson(json['gradeId']) : null;
//   }

//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (gradeId != null) {
//       data['gradeId'] = gradeId!.toJson();
//     }
//     return data;
//   }
// }

class GradeId {
  @HiveField(0)
  int? id;
  @HiveField(1)
  SubClientId? subClientId;
  @HiveField(2)
  String? name;
  @HiveField(3)
  int? order;

  GradeId({this.id, this.subClientId, this.name, this.order});

  GradeId.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    subClientId = json['subClientId'] != null
        ? SubClientId.fromJson(json['subClientId'])
        : null;
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (subClientId != null) {
      data['subClientId'] = subClientId!.toJson();
    }
    data['name'] = name;
    data['order'] = order;
    return data;
  }
}

class SubClientId {
  int? id;
  MainClientId? mainClientId;
  String? name;
  String? address1;
  String? postalCode;
  String? locality;
  String? country;
  String? contactEmail;
  String? contactNumber;
  int? viewCosts;
  int? limitedView;

  SubClientId(
      {this.id,
      this.mainClientId,
      this.name,
      this.address1,
      this.postalCode,
      this.locality,
      this.country,
      this.contactEmail,
      this.contactNumber,
      this.viewCosts,
      this.limitedView});

  SubClientId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainClientId = json['mainClientId'] != null
        ? MainClientId.fromJson(json['mainClientId'])
        : null;
    name = json['name'];
    address1 = json['address1'];
    postalCode = json['postalCode'];
    locality = json['locality'];
    country = json['country'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];
    viewCosts = json['viewCosts'];
    limitedView = json['limitedView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (mainClientId != null) {
      data['mainClientId'] = mainClientId!.toJson();
    }
    data['name'] = name;
    data['address1'] = address1;
    data['postalCode'] = postalCode;
    data['locality'] = locality;
    data['country'] = country;
    data['contactEmail'] = contactEmail;
    data['contactNumber'] = contactNumber;
    data['viewCosts'] = viewCosts;
    data['limitedView'] = limitedView;
    return data;
  }
}

class MainClientId {
  int? id;
  String? name;
  String? address1;
  String? postalCode;
  dynamic locality;
  dynamic country;
  String? contactEmail;
  dynamic contactNumber;

  MainClientId(
      {this.id,
      this.name,
      this.address1,
      this.postalCode,
      this.locality,
      this.country,
      this.contactEmail,
      this.contactNumber});

  MainClientId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    postalCode = json['postalCode'];
    locality = json['locality'];
    country = json['country'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address1'] = address1;
    data['postalCode'] = postalCode;
    data['locality'] = locality;
    data['country'] = country;
    data['contactEmail'] = contactEmail;
    data['contactNumber'] = contactNumber;
    return data;
  }
}
