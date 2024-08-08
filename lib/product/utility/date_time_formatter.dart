import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
final class DateTimeFormatter {
  const DateTimeFormatter._();
  static String formatValue(DateTime value) {
    final formattedValue = DateFormat('yyyy-MM-dd').format(value);
    return formattedValue;
  }

  static String formatValueDetail(DateTime value) {
    final formattedValue = DateFormat('dd MMM yyyy HH:mm').format(value);
    return formattedValue;
  }
}
