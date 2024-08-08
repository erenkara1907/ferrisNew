import 'package:ferrisfwt/feature/inspections/presentation/widget/item_check_list_model.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/utility/enums/Item_check_list_enum.dart';
import 'package:flutter/material.dart';

class InspectionItemChecklistItem extends StatelessWidget {
  static const String routeName = '/inspections/item_checklist';

  const InspectionItemChecklistItem({
    required this.data,
    required this.onChanged,
    this.errorMessage,
    super.key,
  });

  final ItemChecklistModel data;
  final String? errorMessage;
  final Function(ChecklistItemOption?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RichText(
            text: TextSpan(
              text: data.title,
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        if (errorMessage != null) const SizedBox(height: 2),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: RadioListTile<ChecklistItemOption>(
                title: Text(ChecklistItemOption.yes.label,
                    style: context.textTheme.bodyMedium),
                value: ChecklistItemOption.yes,
                groupValue: data.selectedOption,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<ChecklistItemOption>(
                title: Text(ChecklistItemOption.no.label,
                    style: context.textTheme.bodyMedium),
                value: ChecklistItemOption.no,
                groupValue: data.selectedOption,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<ChecklistItemOption>(
                title: Text(ChecklistItemOption.notApplicable.label,
                    style: context.textTheme.bodyMedium),
                value: ChecklistItemOption.notApplicable,
                groupValue: data.selectedOption,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
