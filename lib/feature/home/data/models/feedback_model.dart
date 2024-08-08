import 'package:hive/hive.dart';

part 'feedback_model.g.dart';

@HiveType(typeId: 111)
class FeedbackModel {
  @HiveField(0)
  final String customerFeedback;
  @HiveField(1)
  final String vehicleFeedback;

  FeedbackModel({
    required this.customerFeedback,
    required this.vehicleFeedback,
  });
}
