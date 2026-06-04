import 'package:widyu/core/model/myPage/point/point.dart';

class PointUiModel {
  final bool isEarningPoint;
  final int amount;
  final String description;
  final DateTime createdAt;

  PointUiModel({
    required this.isEarningPoint,
    required this.amount,
    required this.description,
    required this.createdAt,
  });
}

extension PointHistoryExtension on Point {
  PointUiModel toUiModel() {
    return PointUiModel(
      isEarningPoint: type == 'EARN',
      amount: amount,
      description: description,
      createdAt: createdAt,
    );
  }
}
