import 'package:ferrisfwt/feature/auth/presentation/view/login_page.dart';
import 'package:ferrisfwt/product/state/base/mixin/base_mixin.dart';
import 'package:flutter/material.dart';

mixin LoginMixin on BaseMixin<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}
