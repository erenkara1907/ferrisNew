import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/expense_detail_page.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditDetailsPage extends StatefulWidget {
  final int jobInspectionId;
  final JobInspectionResponseModelItem inspection;
  final String odo;
  final int fuelLevel;
  const EditDetailsPage({
    super.key,
    required this.jobInspectionId,
    required this.inspection,
    required this.odo,
    required this.fuelLevel,
  });

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  final TextEditingController _odoReadingController = TextEditingController();
  int? _selectedFuelLevel;

  final List<int> fuelLevel = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  @override
  Widget build(BuildContext context) {
    final bool isSigned =
        ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign !=
                null &&
            ProductStateItems.hiveDatabaseManager
                .getUserModel()!
                .inspectionsSign!
                .contains(widget.jobInspectionId);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: context.theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              if (_odoReadingController.text.isNotEmpty ||
                  _selectedFuelLevel != null) {
                context.pop();
              } else {
                context.pop();
              }
            },
          ),
          centerTitle: true,
          backgroundColor: context.theme.colorScheme.surface,
          title: Text(
            'Details',
            style: context.textTheme.titleSmall,
          ),
        ),
        body: BlocConsumer<InspectionsBloc, InspectionsState>(
          listenWhen: (previous, current) => current.status != previous.status,
          listener: (context, state) {
            if (state.status == ViewStatus.success) {
              showTopSnackBarFr(context, message: 'Details added successfully');

              context.pop();
            }
            if (state.status == ViewStatus.failure) {
              // BotToast.showText(text: state.failure.toString());
            }
          },
          builder: (context, state) {
            if (state.status == ViewStatus.loading) {
              _selectedFuelLevel = null;
              _odoReadingController.clear();
              return const Center(child: LoadingProgress());
            }
            return SingleChildScrollView(
              child: Padding(
                padding: context.paddingAllDefault,
                child: Column(children: [
                  CustomJobTextfield(
                    keyboardType: TextInputType.number,
                    text: "Odo Reading(Miles)",
                    hintText: widget.odo,
                    controller: _odoReadingController,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    hintText:
                        widget.fuelLevel == 0 ? "-" : "${widget.fuelLevel}%",
                    items: fuelLevel.map((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text("$value %"),
                      );
                    }).toList(),
                    text: "Fuel Level",
                    onChanged: (text) {
                      setState(() {
                        _selectedFuelLevel = int.parse(text!);
                      });
                    },
                    textSpanEnable: false,
                    value: _selectedFuelLevel?.toString(),
                    // value: _selectedFuelLevel != null
                    //     ? _selectedFuelLevel.toString()
                    //     : '',
                  ),
                  const VerticalSpace.large(),
                  if (!isSigned)
                    CustomAppButton(
                        text: "Save",
                        ontap: () {
                          context.read<InspectionsBloc>().add(
                                InspectionsItemDetail(
                                  isAsync: false,
                                  odoReading:
                                      _odoReadingController.text.isNotEmpty
                                          ? double.tryParse(
                                                  _odoReadingController.text
                                                      .trim()) ??
                                              0
                                          : widget.odo.isNotEmpty
                                              ? double.tryParse(
                                                      widget.odo.trim()) ??
                                                  0
                                              : 0,
                                  fuelLevel:
                                      _selectedFuelLevel ?? widget.fuelLevel,
                                  inspectionId: widget.jobInspectionId,
                                ),
                              );
                        }),
                ]),
              ),
            );
          },
        ));
  }
}

class DropdownButtonWidget extends StatelessWidget {
  final String text;

  final List<DropdownMenuItem<String>>? items;

  final Function(String?)? onChanged;

  final String hintText;

  final bool textSpanEnable;

  final String? value;

  const DropdownButtonWidget(
      {Key? key,
      required this.text,
      required this.items,
      required this.onChanged,
      required this.hintText,
      required this.textSpanEnable,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(text: text),
              TextSpan(
                text: textSpanEnable == true ? "*" : "",
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const VerticalSpace.xxSmall(),
        SizedBox(
          height: context.dynamicHeight(0.08),
          child: DropdownButtonFormField<String>(
            icon: Icon(
              CupertinoIcons.chevron_down,
              color: context.theme.colorScheme.outline,
              size: 18,
              weight: 1.0,
            ),
            decoration: InputDecoration(
              fillColor: context.theme.colorScheme.onSurfaceVariant,
              filled: true,
              hintText: hintText,
              hintStyle: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onPrimary,
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
            style: context.textTheme.bodyMedium,
            items: items,
            value: items!.any((item) => item.value == value) ? value : null,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
