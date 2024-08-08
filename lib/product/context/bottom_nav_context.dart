import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final class BottomNavContext extends ChangeNotifier {
  int _index = 0;

  final List<SvgPicture> _pagesIcon = [
    SvgPicture.asset(
      "assets/images/icons/home-page.svg",
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    ),
    SvgPicture.asset(
      "assets/images/icons/history-page.svg",
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    ),
    SvgPicture.asset(
      "assets/images/icons/profile-page.svg",
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    ),
  ];

  List<SvgPicture> get items => _pagesIcon;

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
