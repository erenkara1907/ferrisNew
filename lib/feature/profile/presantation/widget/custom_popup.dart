import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomPopupDialog extends StatelessWidget {
  final String popupText;
  final String confirmText;
  final String cancelText;
  final Function(BuildContext) onConfirm;
  final Function(BuildContext)? onCancel;

  final String? iconPath;

  const CustomPopupDialog({
    super.key,
    required this.popupText,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.theme.colorScheme.surface,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconPath != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                iconPath ?? "assets/images/icons/logout.svg",
                width: context.dynamicWidth(0.1),
                height: context.dynamicHeight(0.1),
                color: context.theme.colorScheme.primaryContainer,
              ),
            ),
          const VerticalSpace.small(),
          Text(
            popupText,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomGreyAppButton(
              width: context.dynamicWidth(0.3),
              textColor: context.theme.colorScheme.onSurface,
              text: cancelText,
              containerColor: context.theme.colorScheme.outline,
              ontap: () {
                if (onCancel != null) {
                  onCancel!(context);
                }
                context.pop();
              },
            ),
            const HorizontalSpace.xxSmall(),
            CustomGreyAppButton(
              width: context.dynamicWidth(0.3),
              textColor: context.theme.colorScheme.onSurfaceVariant,
              text: confirmText,
              containerColor: context.theme.colorScheme.primaryContainer,
              ontap: () {
                onConfirm(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

void showCustomPopupDialog(
  BuildContext context, {
  required String popupText,
  required String confirmText,
  required String cancelText,
  required Function(BuildContext) onConfirm,
  Function(BuildContext)? onCancel,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return CustomPopupDialog(
        popupText: popupText,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      );
    },
    barrierLabel: "Dialog",
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: true,
  );
}

void showTopSnackBar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
  Color textColor = Colors.white,
  String iconPath = "assets/images/icons/check-circle.png",
  Color iconColor = Colors.green,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      height: 58,
      top: 20.0,
      left: MediaQuery.of(context).size.width * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: context.paddingAllDefault,
            child: Row(
              children: [
                if (iconPath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      iconPath,
                      color: iconColor,
                      width: 24,
                      height: 24,
                    ),
                  ),
                Text(
                  message,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}
