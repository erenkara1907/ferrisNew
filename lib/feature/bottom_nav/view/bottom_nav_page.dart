
import 'package:ferrisfwt/feature/bottom_nav/widget/bottom_nav_builder_widget.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class BottomNavPage extends StatefulWidget {
  const BottomNavPage({required this.child, super.key});
  final Widget? child;

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  @override
  void initState() {
    super.initState();
    context.read<CubitPermissions>().checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBuilder(),
      body: widget.child,
    );
  }
}
