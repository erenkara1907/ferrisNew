import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/expense_detail_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/damage_recorder&add_page.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../data/models/condition_image/condition_image_response_model.dart';

class SignInspectionPage extends StatefulWidget {
  final JobInspectionResponseModelItem inspection;
  const SignInspectionPage({super.key, required this.inspection});

  @override
  State<SignInspectionPage> createState() => _SignInspectionPageState();
}

class _SignInspectionPageState extends State<SignInspectionPage> {
  late final HiveStorageManager _hiveStorageManager;
  Uint8List? exportedImage;
  final TextEditingController _controllerText = TextEditingController();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );
  Future push(context, widget) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    await push(
      context,
      Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.surface,
          title: const Text('PNG Image'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[300],
            child: Image.memory(data),
          ),
        ),
      ),
    );
  }

  Future<void> exportSVG(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarSVG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final SvgPicture data = _controller.toSVG()!;

    if (!mounted) return;

    await push(
      context,
      Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.surface,
          title: const Text('SVG Image'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[300],
            child: data,
          ),
        ),
      ),
    );
  }

  String? filePath;

  Future<void> setFilePath() async {
    final documentPath = (await getApplicationDocumentsDirectory()).path;

    setState(() {
      filePath = documentPath;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<InspectionsBloc>().add(SetGetDamages(
          widget.inspection.id ?? 0,
        ));

    context.read<InspectionsBloc>().add(SetGetConditionImages(
          widget.inspection.id ?? 0,
        ));
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    setFilePath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel_outlined,
            color: context.theme.colorScheme.primary,
            size: 24,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        backgroundColor: context.theme.colorScheme.surface,
        title: Text(
          'Customer Signature',
          style: context.textTheme.titleSmall
              ?.copyWith(color: context.theme.colorScheme.primary),
        ),
      ),
      body: BlocBuilder<InspectionsBloc, InspectionsState>(
        builder: (context, state) {
          if (filePath == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: context.paddingAllDefault,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Inspection Detail",
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        color: context.theme.colorScheme.primary,
                      ),
                      InspectionSignInfoWidget(
                        inspection: widget.inspection,
                      ),
                      const VerticalSpace.small(),
                      InspectionDamagesWidget(
                        standarIds: widget.inspection.damageStandards ?? [],
                        inspectionId: widget.inspection.id ?? 1,
                        state: state,
                      ),
                      InspectionConditionImageWidget(
                        filePath: filePath,
                        state: state,
                        updateModel: _hiveStorageManager
                            .getConditionImages(widget.inspection.id!),
                        jobInspectionId: widget.inspection.id!,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer Information",
                              style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600)),
                          Divider(
                            color: context.theme.colorScheme.primary,
                          ),
                          Card(
                            elevation: 8,
                            child: Container(
                              width: context.dynamicWidth(0.97),
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: context.paddingHorizontalLow,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const VerticalSpace.small(),
                                    CustomJobTextfield(
                                        textInputAction: TextInputAction.done,
                                        text: "Customer Full Name",
                                        hintText: "Enter the name",
                                        controller: _controllerText),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpace.small(),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign",
                              style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600)),
                          Divider(
                            color: context.theme.colorScheme.primary,
                          ),
                          Card(
                            elevation: 8,
                            child: Container(
                              height: 195,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: context
                                        .theme.colorScheme.primaryContainer),
                              ),
                              child: Signature(
                                key: const Key('signature'),
                                controller: _controller,
                                height: 180,
                                width: context.width - 30,
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 238, 238),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (exportedImage != null)
                            Image.memory(exportedImage!)
                        ],
                      ),
                      const VerticalSpace.small(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppButton(
                              text: 'Clear Signature',
                              ontap: () {
                                _controller.clear();
                                exportedImage = null;
                              }),
                          SizedBox(
                            height: context.dynamicHeight(0.01),
                          ),
                          CustomAppButton(
                              text: 'Continue',
                              ontap: () async {
                                exportedImage = await _controller.toPngBytes();
                                if (exportedImage == null) {
                                  BotToast.showText(
                                    text: "Please sign the inspection",
                                  );
                                  return;
                                }

                                if (_controllerText.text.isEmpty) {
                                  BotToast.showText(
                                    text: "Please enter the customer name",
                                  );
                                  return;
                                }

                                context
                                    .read<InspectionsBloc>()
                                    .add(SetCustomerImage(
                                      exportedImage!,
                                      _controllerText.text,
                                    ));
                                context.push('/sign_inspection_page2', extra: {
                                  'inspectionId': widget.inspection.id,
                                });
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  return dateFormat.format(dateTime);
}

class InspectionSignInfoWidget extends StatelessWidget {
  final JobInspectionResponseModelItem inspection;
  const InspectionSignInfoWidget({
    required this.inspection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDate(inspection.date!);
    return BlocBuilder<InspectionsBloc, InspectionsState>(
      builder: (context, state) {
        final gradeText = state.damageResponse.isNotEmpty
            ? state.damageResponse[state.damageResponse.length - 1].gradeId
            : inspection.gradleItem != null
                ? inspection.gradleItem!.name
                : "-";
        return Card(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:
                  context.paddingHorizontalDefault + context.paddingVerticalLow,
              child: Column(
                children: [
                  const VerticalSpace.xxSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vehicle',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                          context
                                  .read<HomeBloc>()
                                  .state
                                  .showJob
                                  ?.vehicleId
                                  ?.name ??
                              "",
                          style: context.textTheme.bodyMedium)
                    ],
                  ),
                  Divider(
                    thickness: 0.35,
                    color: context.theme.colorScheme.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grade',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(gradeText ?? "", style: context.textTheme.bodyMedium)
                    ],
                  ),
                  Divider(
                    thickness: 0.35,
                    color: context.theme.colorScheme.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Odometer',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        inspection.odoReading == null
                            ? state.odo == 0
                                ? '-'
                                : "${state.odo.toInt()} Miles"
                            : "${state.odo == 0 ? inspection.odoReading!.toInt() : state.odo.toInt()} Miles",
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.35,
                    color: context.theme.colorScheme.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Name',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                          context
                                  .read<HomeBloc>()
                                  .state
                                  .showJob
                                  ?.driverId!
                                  .name ??
                              "",
                          style: context.textTheme.bodyMedium)
                    ],
                  ),
                  Divider(
                    thickness: 0.35,
                    color: context.theme.colorScheme.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(formattedDate ?? "",
                          style: context.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InspectionConditionImageWidget extends StatefulWidget {
  final InspectionsState state;
  final String? filePath;
  List<ConditionImageResponseModel>? updateModel;
  final int jobInspectionId;
  InspectionConditionImageWidget({
    required this.state,
    required this.updateModel,
    required this.jobInspectionId,
    required this.filePath,
    super.key,
  });

  @override
  State<InspectionConditionImageWidget> createState() =>
      _InspectionConditionImageWidgetState();
}

class _InspectionConditionImageWidgetState
    extends State<InspectionConditionImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Condition Images",
            style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w600)),
        Divider(
          color: context.theme.colorScheme.primary,
        ),
        Card(
          elevation: 8,
          child: Container(
            width: context.dynamicWidth(0.97),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
                padding: context.paddingAllDefault,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.updateModel?.isNotEmpty ?? false)
                      SizedBox(
                        height: context.dynamicHeight(0.15),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) =>
                              const HorizontalSpace.xSmall(),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.updateModel?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final pathImage =
                                widget.updateModel![index].imageFile!.path;
                            int documentsIndex =
                                pathImage.indexOf("Documents/");
                            String result = pathImage.substring(
                                documentsIndex + "Documents/".length);

                            final path = '${widget.filePath}/$result';

                            return Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                      height: context.dynamicHeight(0.15),
                                      width: context.dynamicWidth(0.35),
                                    )),
                              ],
                            );
                          },
                        ),
                      )
                    else
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/fr_car_damage.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                          const VerticalSpace.xSmall(),
                          Text("No condition images found",
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                )),
          ),
        ),
        const VerticalSpace.small(),
      ],
    );
  }
}

class InspectionDamagesWidget extends StatelessWidget {
  final InspectionsState state;
  final int inspectionId;
  final List<int> standarIds;
  const InspectionDamagesWidget({
    required this.state,
    required this.inspectionId,
    required this.standarIds,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final total = state.damageResponse.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (element.price != null ? element.price!.toInt() : 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Damages",
            style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w600)),
        Divider(
          color: context.theme.colorScheme.primary,
        ),
        Card(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: context.paddingHorizontalLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.damageResponse.isNotEmpty)
                    SizedBox(
                      height: context.dynamicHeight(0.21),
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const HorizontalSpace.xSmall(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.damageResponse.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DamageCardWidget(
                              standarIds: standarIds,
                              inspection: inspectionId,
                              damageResponse: state.damageResponse[index]);
                        },
                      ),
                    )
                  else
                    Padding(
                      padding: context.paddingTopLow,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/fr_car_damage.png',
                              height: 60,
                              width: 60,
                            ),
                            Text("No damages found",
                                style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  const VerticalSpace.small(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    total != 0
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    context.theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: context.paddingAllDefault,
                                child: Text(
                                  "Total: £${total.toStringAsFixed(2)}",
                                  style: context.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.surface),
                                ),
                              ),
                            ),
                          )
                        : const Center(),
                  ]),
                  // Padding(
                  //   padding: context.paddingAllDefault,
                  //   child: Text(
                  //       textAlign: TextAlign.center,
                  //       "If you do not have an internet connection when adding damage, the G value may be out of date.",
                  //       style: context.textTheme.bodySmall?.copyWith(
                  //           color: context.theme.colorScheme.error,
                  //           fontWeight: FontWeight.w600)),
                  // )
                ],
              ),
            ),
          ),
        ),
        const VerticalSpace.small(),
      ],
    );
  }
}
