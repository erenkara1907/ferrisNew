import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngBoundsGenerator on List<LatLng> {
  /// find the [LatLngBounds] for list of [LatLng]
  LatLngBounds generateLatLngBounds() {
    assert(isNotEmpty);
    double north = this[0].latitude;
    double south = this[0].latitude;
    double west = this[0].longitude;
    double east = this[0].longitude;
    for (LatLng m in this) {
      if (m.latitude > north) north = m.latitude;
      if (m.latitude < south) south = m.latitude;
      if (m.longitude > east) east = m.longitude;
      if (m.longitude < west) west = m.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(north, east),
      southwest: LatLng(south, west),
    );
  }
}

extension LatLngSerialize on LatLng {
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

extension DateAndTime on DateTime {
  /// returns the date and time in this format: yyyy-MM-dd HH:mm:ss. compatible
  /// with mysql datetime format.
  String get toDateAndTimeFormat {
    return '$toDateFormat $toTimeFormat';
  }

  /// returns the date in this format: yyyy-MM-dd. compatible with mysql date
  /// format.
  String get toDateFormat {
    return '${_fourDigits(year)}-${_twoDigits(month)}-${_twoDigits(day)}';
  }

  /// returns the time in this format: HH:mm:ss. compatible with mysql time
  /// format.
  String get toTimeFormat {
    return '${_twoDigits(hour)}:${_twoDigits(minute)}:${_twoDigits(second)}';
  }

  /// returns the time in this format: HH:mm.
  String get toHourAndMinuteFormat {
    return '${_twoDigits(hour)}:${_twoDigits(minute)}';
  }
}

extension TimeOfDayFormat on TimeOfDay {
  /// returns the time in this format: HH:mm.
  String get toHourAndMinuteFormat {
    return '${_twoDigits(hour)}:${_twoDigits(minute)}';
  }

  /// returns the time in this format: HH:mm. compatible with mysql time.
  static TimeOfDay? fromString(String? time) {
    if (time == null) return null;
    final List<int> parts = time.split(':').map((e) => int.parse(e)).toList();
    assert(parts.length == 2);
    return TimeOfDay(hour: parts[0], minute: parts[1]);
  }
}

extension DateTimeVirtualizeExtension on DateTime {
  String toBeautifulFormat({
    bool includeTime = false,
  }) {
    int dayOfMount = day;
    String daySuffix = _findOrdinarySuffixFor(dayOfMount);
    String monthResult = _months[month - 1];
    final dateResult = '$dayOfMount$daySuffix $monthResult $year';
    if (!includeTime) {
      return dateResult;
    }
    final timeResult = '${_twoDigits(hour)}:${_twoDigits(minute)}';
    return '$dateResult | $timeResult';
  }

  static String _findOrdinarySuffixFor(int n) {
    String? daySuffix;
    if (n == 11 || n == 12 || n == 13) {
      daySuffix = 'th';
    }
    if (daySuffix == null) {
      switch (n % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
          break;
      }
    }
    return daySuffix;
  }

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}

String _fourDigits(int n) {
  if (n >= 1000) return '$n';
  if (n >= 100) return '0$n';
  if (n >= 10) return '00$n';
  return '000$n';
}

String _twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

extension LatLngConvert on Position {
  LatLng get toLatLng => LatLng(latitude, longitude);
}
