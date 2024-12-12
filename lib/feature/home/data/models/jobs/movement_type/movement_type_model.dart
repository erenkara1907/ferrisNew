import 'package:ferrisfwt/feature/home/data/models/jobs/tracking_status_model.dart';
import 'package:hive/hive.dart';

import 'feedback_input_availability.dart';

part 'movement_type_model.g.dart';

@HiveType(typeId: 106)
class MovementTypeModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<String> availableFuelEvLevelInputs;
  @HiveField(3)
  final List<String> availableTimeInputs;
  @HiveField(4)
  final List<TrackingStatusModel> availableTrackingStatuses;
  @HiveField(5)
  final FeedbackInputAvailability? feedbackInputs;
  @HiveField(6)
  final bool? isAvailableValetStandardInput;

  MovementTypeModel({
    required this.id,
    required this.name,
    required this.availableFuelEvLevelInputs,
    required this.availableTimeInputs,
    required this.availableTrackingStatuses,
    this.feedbackInputs,
    this.isAvailableValetStandardInput,
  });

  String get nameCapitalized {
    String result = name;
    if (name.isEmpty) return name;
    result = name.replaceRange(0, 1, name.substring(0, 1).toUpperCase());
    for (int i = 0; i < name.length - 1; i++) {
      if (name[i] == ' '[0]) {
        result = result.replaceRange(i + 1, i + 2, name.substring(i + 1, i + 2).toUpperCase());
      }
    }
    return result;
  }

  factory MovementTypeModel.fromMap(Map<String, dynamic> map) {
    final result = MovementTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      availableFuelEvLevelInputs: List<String>.from(map['availableFuelEvLevelInputs'] as List<dynamic>? ?? []),
      availableTimeInputs: List<String>.from(map['availableTimeInputs'] as List<dynamic>? ?? []),
      availableTrackingStatuses:
          (map['availableTrackingStatuses'] == null || (map['availableTrackingStatuses'] as List?)!.isEmpty)
              ? []
              : ((map['availableTrackingStatuses'] as List)[0] is Map
                  ? map['availableTrackingStatuses']
                      .map<TrackingStatusModel>((x) => TrackingStatusModel.fromMap(x))
                      .toList()
                  : []),
      feedbackInputs: map['feedbackInputs'] != null
          ? FeedbackInputAvailability.fromMap(map['feedbackInputs'] as Map<String, dynamic>)
          : null,
      isAvailableValetStandardInput: map['isAvailableValetStandardInput'] as bool?,
    );
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'availableFuelEvLevelInputs': availableFuelEvLevelInputs,
      'availableTimeInputs': availableTimeInputs,
      'availableTrackingStatuses': availableTrackingStatuses.map((e) => e.toMap()).toList(),
      'feedbackInputs': feedbackInputs?.toMap(),
      'isAvailableValetStandardInput': isAvailableValetStandardInput,
    };
  }

  bool get showValetStandardInput => isAvailableValetStandardInput ?? false;

  bool get showDepartedHubTime => availableTimeInputs.contains('time_departed_hub');

  bool get showArrivedCustomerTime => availableTimeInputs.contains('time_arrived_at_customer');

  bool get showDepartedCustomerTime => availableTimeInputs.contains('time_departed_customer');

  @override
  String toString() => '$runtimeType(${toMap().toString()})';
}
