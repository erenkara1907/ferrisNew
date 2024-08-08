import 'package:ferrisfwt/feature/profile/presantation/view/personal_data_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AutoDarkModePage extends StatefulWidget {
  const AutoDarkModePage({Key? key}) : super(key: key);

  @override
  State<AutoDarkModePage> createState() => _AutoDarkModePageState();
}

class _AutoDarkModePageState extends State<AutoDarkModePage> {
  String? selectedOption;

  Widget buildOptionTile(String optionText) {
    bool isSelected = selectedOption == optionText;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = optionText;
        });
      },
      child: Padding(
        padding: context.paddingAllDefault,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isSelected)
              Container(
                width: 5,
                child: Icon(
                  size: 18,
                  Icons.check,
                  color: context.theme.colorScheme.primaryContainer,
                ),
              ),
            const HorizontalSpace.small(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(optionText, style: context.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.surfaceVariant,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            size: context.dynamicWidth(0.045),
            Icons.arrow_back_ios,
            color: context.theme.colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: context.paddingAllDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Auto-dark mode",
              style: context.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const VerticalSpace.small(),
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  buildOptionTile("Disabled"),
                  const ProfileCustomDivider(),
                  buildOptionTile("Scheduled"),
                  const ProfileCustomDivider(),
                  buildOptionTile("Automatically"),
                ],
              ),
            ),
            if (selectedOption !=
                null) // Seçilen bir seçenek varsa altında bir widget göster
              Expanded(
                child: buildSelectedOptionWidget(selectedOption!),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedOptionWidget(String optionText) {
    // Burada seçilen seçeneğe göre bir widget döndürebilirsiniz
    // Örneğin:
    return Container(
        child: selectedOption == "Scheduled"
            ? const SelectedScheduled()
            : selectedOption == "Automatically"
                ? const SelectedAutomatically()
                : const SelectedDisabled());
  }
}

class SelectedDisabled extends StatefulWidget {
  const SelectedDisabled({super.key});

  @override
  State<SelectedDisabled> createState() => _SelectedDisabledState();
}

class _SelectedDisabledState extends State<SelectedDisabled> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surfaceVariant,
    );
  }
}

class SelectedScheduled extends StatefulWidget {
  const SelectedScheduled({Key? key}) : super(key: key);

  @override
  State<SelectedScheduled> createState() => _SelectedScheduledState();
}

class _SelectedScheduledState extends State<SelectedScheduled> {
  bool _switchValue = false;
  late TimeOfDay _selectedFromTime;
  late TimeOfDay _selectedToTime;

  @override
  void initState() {
    super.initState();
    _selectedFromTime = TimeOfDay.now();
    _selectedToTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace.small(),
        Text(
          "Schedule",
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const VerticalSpace.small(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sun-Synced Mode",
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  "According to the time of sunrise and sunset",
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
            SwitchButtonWidget(
              switchValue: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ],
        ),
        const VerticalSpace.small(),
        if (_switchValue)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Location",
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "Current location",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.theme.colorScheme.surfaceTint,
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "From",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      _showTimePicker(isFromTime: true);
                    },
                    child: Row(
                      children: [
                        Text(
                          "${_selectedFromTime.format(context)}",
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.theme.colorScheme.surfaceTint,
                          ),
                        ),
                        const HorizontalSpace.small(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: context.theme.colorScheme.surfaceTint,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const VerticalSpace.small(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "To",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      _showTimePicker(isFromTime: false);
                    },
                    child: Row(
                      children: [
                        Text(
                          "${_selectedToTime.format(context)}",
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.theme.colorScheme.surfaceTint,
                          ),
                        ),
                        const HorizontalSpace.small(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: context.theme.colorScheme.surfaceTint,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _showTimePicker({required bool isFromTime}) async {
    final TimeOfDay? pickedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              height: context.dynamicHeight(0.4),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    if (isFromTime) {
                      _selectedFromTime = TimeOfDay.fromDateTime(newDateTime);
                    } else {
                      _selectedToTime = TimeOfDay.fromDateTime(newDateTime);
                    }
                  });
                },
              ),
            ),
            CustomAppButton(
              text: 'Confirm',
              ontap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isFromTime) {
          _selectedFromTime = pickedTime;
        } else {
          _selectedToTime = pickedTime;
        }
      });
      print(
          'Selected Time: ${isFromTime ? _selectedFromTime : _selectedToTime}');
    }
  }
}

class SelectedAutomatically extends StatefulWidget {
  const SelectedAutomatically({super.key});

  @override
  State<SelectedAutomatically> createState() => _SelectedAutomaticallyState();
}

class _SelectedAutomaticallyState extends State<SelectedAutomatically> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace.small(),
          Text(
            "Automatic Dark mode",
            style: context.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            "Switch to Dark Mode if indoor lighting is low.",
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class SwitchButtonWidget extends StatelessWidget {
  final bool switchValue;
  final ValueChanged<bool>? onChanged;

  const SwitchButtonWidget({
    Key? key,
    required this.switchValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.dynamicWidth(0.1),
      child: CupertinoSwitch(
        value: switchValue,
        onChanged: onChanged,
        activeColor: Theme.of(context)
            .colorScheme
            .primaryContainer, // Customize active color
        trackColor:
            Theme.of(context).colorScheme.surface, // Customize track color
      ),
    );
  }
}
