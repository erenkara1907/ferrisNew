import 'package:equatable/equatable.dart';

abstract class BaseModel<T> extends Equatable {
  Map<String, Object?> toJson();
  T fromJson(Map<String, Object?> json);

  @override
  List<Object?> get props => [];
}
