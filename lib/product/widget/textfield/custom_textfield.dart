import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  String text;
  String hintText;
  Function(String)? onChanged;
  IconButton? suffixIcon;
  bool obscureText;
  TextEditingController? controller;
  String? Function(dynamic value)? validator;

  CustomTextfield({
    super.key,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    required this.text,
    required this.hintText,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontalDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 14, color: context.theme.colorScheme.primary),
              ),
              SizedBox(height: context.dynamicHeight(0.01)),
              TextField(
                controller: controller,
                onChanged: onChanged,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  suffixIcon: suffixIcon,
                  hintStyle: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.outline,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
