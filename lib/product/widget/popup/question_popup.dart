import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionPopup extends StatefulWidget {
  const QuestionPopup(
      {super.key,
      required this.actionButtonText,
      required this.title,
      required this.description,
      required this.actionButtonOnPressed,
      required this.iconPath});
  final String actionButtonText;
  final String title;
  final String description;
  final void Function() actionButtonOnPressed;
  final String iconPath;

  @override
  State<QuestionPopup> createState() => _QuestionPopupState();
}

class _QuestionPopupState extends State<QuestionPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontalLow,
      child: AlertDialog(
        contentPadding: EdgeInsetsDirectional.symmetric(
            vertical: context.dynamicHeight(0.020),
            horizontal: context.dynamicWidth(0.06)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: context.theme.colorScheme.background,
        insetPadding: EdgeInsets.symmetric(
            vertical: context.dynamicHeight(0.02),
            horizontal: context.dynamicWidth(0.02)),
        icon: Image.asset(
          widget.iconPath,
          width: 70,
          height: 70,
        ),
        title: Text(
          widget.title,
          style: context.textTheme.titleSmall,
        ),
        content: Text(
          widget.description,
          style: context.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: context.dynamicHeight(0.05),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: context.theme.colorScheme.primary
                                    .withOpacity(0.7)))),
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Cancel',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: context.dynamicHeight(0.05),
                  child: CustomAppButton(
                      text: widget.actionButtonText,
                      ontap: widget.actionButtonOnPressed),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

void showTopSnackBarFr(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 2),
  Color textColor = Colors.white,
  String iconPath = "assets/images/icons/check-circle.png",
  Color iconColor = Colors.green,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      height: 58,
      top: 40.0,
      left: MediaQuery.of(context).size.width * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
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
