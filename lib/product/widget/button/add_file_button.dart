// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddFileButton extends StatelessWidget {
  const AddFileButton({
    Key? key,
    required this.fileCount,
  }) : super(key: key);

  final int fileCount;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      radius: const Radius.circular(12),
      borderType: BorderType.RRect,
      color: context.theme.colorScheme.primaryContainer,
      strokeWidth: 1,
      dashPattern: const [6, 3],
      child: Container(
          padding: EdgeInsets.zero,
          width: double.infinity,
          // height: 162.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/icons/ic_upload_image.svg"),
                const SizedBox(height: 12.0),
                Text(
                  "Upload Image",
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "You can upload max $fileCount files",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
