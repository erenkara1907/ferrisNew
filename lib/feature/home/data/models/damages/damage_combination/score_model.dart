// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'score_model.g.dart';

@HiveType(typeId: 143)
class ScoreModel {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final int inspectionId;

  ScoreModel({
    required this.score,
    required this.inspectionId,
  });

  ScoreModel copyWith({
    int? score,
    int? inspectionId,
  }) {
    return ScoreModel(
      score: score ?? this.score,
      inspectionId: inspectionId ?? this.inspectionId,
    );
  }
}
