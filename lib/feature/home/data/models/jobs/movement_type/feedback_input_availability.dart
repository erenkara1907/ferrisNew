import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'feedback_input_availability.g.dart';

const String _nameDisabled = 'disabled';
const String _nameRequired = 'required';
const String _nameOptional = 'optional';

@HiveType(typeId: 109)
class FeedbackInputAvailability {
  @HiveField(0)
  FeedbackInputAvailabilityEnum vehicle;
  @HiveField(1)
  FeedbackInputAvailabilityEnum customer;

  FeedbackInputAvailability({
    required this.vehicle,
    required this.customer,
  });

  factory FeedbackInputAvailability.fromMap(Map<String, dynamic> map) {
    return FeedbackInputAvailability(
      vehicle: FeedbackInputAvailabilityEnum.fromString(map['vehicle']),
      customer: FeedbackInputAvailabilityEnum.fromString(map['customer']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle': vehicle.toString(),
      'customer': customer.toString(),
    };
  }

  bool get showAnyInput {
    return vehicle.showInput || customer.showInput;
  }

  bool get inputsTypeKnown {
    return vehicle != FeedbackInputAvailabilityEnum.unknown &&
        customer != FeedbackInputAvailabilityEnum.unknown;
  }

  @override
  String toString() => '$runtimeType(${toMap()})';
}

enum FeedbackInputAvailabilityEnum {
  disabled,
  required,
  optional,
  unknown;

  factory FeedbackInputAvailabilityEnum.fromString(String value) {
    switch (value) {
      case _nameDisabled:
        return FeedbackInputAvailabilityEnum.disabled;
      case _nameRequired:
        return FeedbackInputAvailabilityEnum.required;
      case _nameOptional:
        return FeedbackInputAvailabilityEnum.optional;
      default:
        debugPrint('Unknown enum value: $value');
        return FeedbackInputAvailabilityEnum.unknown;
    }
  }

  bool get showInput {
    switch (this) {
      case FeedbackInputAvailabilityEnum.disabled:
        return false;
      case FeedbackInputAvailabilityEnum.required:
        return true;
      case FeedbackInputAvailabilityEnum.optional:
        return true;
      default:
        return false;
    }
  }

  bool get isRequired {
    switch (this) {
      case FeedbackInputAvailabilityEnum.disabled:
        return false;
      case FeedbackInputAvailabilityEnum.required:
        return true;
      case FeedbackInputAvailabilityEnum.optional:
        return false;
      default:
        return false;
    }
  }

  @override
  String toString() {
    switch (this) {
      case FeedbackInputAvailabilityEnum.disabled:
        return _nameDisabled;
      case FeedbackInputAvailabilityEnum.required:
        return _nameRequired;
      case FeedbackInputAvailabilityEnum.optional:
        return _nameOptional;
      default:
        return 'unknown';
    }
  }
}
