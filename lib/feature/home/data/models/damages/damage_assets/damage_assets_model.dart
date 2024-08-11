import 'package:hive/hive.dart';

part 'damage_assets_model.g.dart';

@HiveType(typeId: 500)
class DamageAssetsModel {
  @HiveField(0)
  bool? status;

  @HiveField(1)
  String? message;

  @HiveField(2)
  List<Data>? data;

  @HiveField(3)
  Debug? debug;

  DamageAssetsModel({this.status, this.message, this.data, this.debug});

  factory DamageAssetsModel.fromJson(Map<String, dynamic> json) {
    return DamageAssetsModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Data.fromJson(item))
          .toList(),
      debug: json['debug'] != null ? Debug.fromJson(json['debug']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
      'debug': debug?.toJson(),
    };
  }
}

@HiveType(typeId: 501)
class Data {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? mainClientId;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? createdAt;

  @HiveField(4)
  String? updatedAt;

  @HiveField(5)
  List<Categories>? categories;

  Data(
      {this.id,
      this.mainClientId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.categories});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      mainClientId: json['main_client_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((item) => Categories.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main_client_id': mainClientId,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'categories': categories?.map((v) => v.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 502)
class Categories {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<Parts>? parts;

  Categories({this.id, this.name, this.parts});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
      parts: (json['parts'] as List<dynamic>?)
          ?.map((item) => Parts.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parts': parts?.map((v) => v.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 503)
class Parts {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? categoryId;

  @HiveField(3)
  List<Issues>? issues;

  Parts({this.id, this.name, this.categoryId, this.issues});

  factory Parts.fromJson(Map<String, dynamic> json) {
    return Parts(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      issues: (json['issues'] as List<dynamic>?)
          ?.map((item) => Issues.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'issues': issues?.map((v) => v.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 504)
class Issues {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? partId;

  @HiveField(3)
  List<Failures>? failures;

  Issues({this.id, this.name, this.partId, this.failures});

  factory Issues.fromJson(Map<String, dynamic> json) {
    return Issues(
      id: json['id'],
      name: json['name'],
      partId: json['part_id'],
      failures: (json['failures'] as List<dynamic>?)
          ?.map((item) => Failures.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'part_id': partId,
      'failures': failures?.map((v) => v.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 505)
class Failures {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? issueId;

  @HiveField(3)
  List<Repairs>? repairs;

  Failures({this.id, this.name, this.issueId, this.repairs});

  factory Failures.fromJson(Map<String, dynamic> json) {
    return Failures(
      id: json['id'],
      name: json['name'],
      issueId: json['issue_id'],
      repairs: (json['repairs'] as List<dynamic>?)
          ?.map((item) => Repairs.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issue_id': issueId,
      'repairs': repairs?.map((v) => v.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 506)
class Repairs {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? failureId;

  Repairs({this.id, this.name, this.failureId});

  factory Repairs.fromJson(Map<String, dynamic> json) {
    return Repairs(
      id: json['id'],
      name: json['name'],
      failureId: json['failure_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'failure_id': failureId,
    };
  }
}

@HiveType(typeId: 507)
class Debug {
  @HiveField(0)
  String? timestamp;

  @HiveField(1)
  double? memoryUsageMb;

  @HiveField(2)
  String? requestMethod;

  @HiveField(3)
  String? requestUri;

  @HiveField(4)
  RequestQuery? requestQuery;

  @HiveField(5)
  String? requestIp;

  Debug(
      {this.timestamp,
      this.memoryUsageMb,
      this.requestMethod,
      this.requestUri,
      this.requestQuery,
      this.requestIp});

  factory Debug.fromJson(Map<String, dynamic> json) {
    return Debug(
      timestamp: json['timestamp'],
      memoryUsageMb: json['memoryUsageMb'],
      requestMethod: json['requestMethod'],
      requestUri: json['requestUri'],
      requestQuery: json['requestQuery'] != null
          ? RequestQuery.fromJson(json['requestQuery'])
          : null,
      requestIp: json['requestIp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'memoryUsageMb': memoryUsageMb,
      'requestMethod': requestMethod,
      'requestUri': requestUri,
      'requestQuery': requestQuery?.toJson(),
      'requestIp': requestIp,
    };
  }
}

@HiveType(typeId: 508)
class RequestQuery {
  @HiveField(0)
  AuthUser? authUser;

  RequestQuery({this.authUser});

  factory RequestQuery.fromJson(Map<String, dynamic> json) {
    return RequestQuery(
      authUser:
          json['authUser'] != null ? AuthUser.fromJson(json['authUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authUser': authUser?.toJson(),
    };
  }
}

@HiveType(typeId: 509)
class AuthUser {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  MainClientId? mainClientId;

  AuthUser({this.id, this.name, this.email, this.mainClientId});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mainClientId: json['mainClientId'] != null
          ? MainClientId.fromJson(json['mainClientId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mainClientId': mainClientId?.toJson(),
    };
  }
}

@HiveType(typeId: 510)
class MainClientId {
  @HiveField(0)
  int? id;

  MainClientId({this.id});

  factory MainClientId.fromJson(Map<String, dynamic> json) {
    return MainClientId(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
