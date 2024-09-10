import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String text;
  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(dynamic value)? validator;

  const CustomDropdownFormField({
    Key? key,
    this.onChanged,
    this.obscureText = false,
    required this.text,
    required this.hintText,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),
            Text(
              "*",
              style: context.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFDA0002),
              ),
            ),
          ],
        ),
        SizedBox(height: context.dynamicHeight(0.01)),
        Form(
          child: SizedBox(
            height: context.dynamicHeight(0.08),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: context.theme.colorScheme.onSurfaceVariant,
                filled: true,
                hintText: widget.hintText,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.outline,
                ),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.onPrimary,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue!);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an item';
                }
                if (widget.validator != null) {
                  return widget.validator!(value);
                }
                return null;
              },
              items: ['Item 1', 'Item 2', 'Item 3'].map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: context.textTheme.bodyLarge,
                  ),
                );
              }).toList(),
              style: context.textTheme.bodyLarge?.copyWith(),
              icon: Icon(
                Icons.arrow_drop_down_sharp,
                color: context.theme.colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
