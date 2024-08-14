import 'package:hive/hive.dart';

part 'gradle_item_model.g.dart';

@HiveType(typeId: 105)
class GradeId {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? order;

  GradeId({this.id, this.name, this.order});

  GradeId.fromMap(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    return data;
  }
}
