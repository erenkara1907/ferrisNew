// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

class ExpenseDetails extends StatefulWidget {
  final int jobId;
  const ExpenseDetails({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedLevelAtHub;
  File? _imageFile;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Future<void> _getImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        PermissionStatus permissionStatus = await Permission.camera.status;
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Camera Permission'),
                content: const Text(
                    'This app needs camera access to take pictures. Please allow camera access in settings.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      context.read<CubitPermissions>().requestCamera();
                      final permissionStatus = await Permission.camera.status;
                      if (permissionStatus.isDenied ||
                          permissionStatus.isPermanentlyDenied) {
                        await openAppSettings();
                      }
                      context.pop();
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            },
          );

          if (result != true) {
            return;
          }

          permissionStatus = await Permission.camera.status;
          if (!permissionStatus.isGranted) {
            BotToast.showText(text: 'Camera access denied');
            return;
          }
        }
      }

      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        File file = File(pickedImage.path);

        final documentPath = (await getApplicationDocumentsDirectory()).path;
        final newFile =
            await file.copy('$documentPath/${path.basename(file.path)}');
        File compressedImage = await _resizeImage(newFile);

        setState(() {
          _imageFile = compressedImage;
        });
        _scrollToEnd();
      } else {
        // print('No image selected.');
      }
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);

      BotToast.showText(text: 'An error occurred while selecting an image.');
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.unfocus();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });

    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  Future<File> _resizeImage(File imageFile) async {
    Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800,
      minHeight: 600,
      quality: 90,
    );

    if (imageBytes == null) {
      throw Exception("Compression failed");
    }

    String fName = path.basenameWithoutExtension(imageFile.path);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressedImagePath = '$appDocPath/$fName.jpg';
    await File(compressedImagePath).writeAsBytes(imageBytes);
    return File(compressedImagePath);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<JobExpenseBloc, JobExpenseState>(
        listener: (context, state) {
          if (state.status == ViewStatus.success) {
            showTopSnackBarFr(context, message: 'Expense added successfully!');
            context.pop();
          }
          if (state.status == ViewStatus.failure) {
            BotToast.showText(text: state.failure.toString());
          }
        },
        builder: (context, state) {
          if (state.status == ViewStatus.loading) {
            _imageFile = null;
            _priceController.clear();
            _reasonController.clear();
            _selectedLevelAtHub = null;
            return const Scaffold(
              body: Center(
                child: LoadingProgress(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.surface,
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
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: context.paddingAllDefault,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Expense Details',
                          style: context.textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const VerticalSpace.xxSmall(),
                    DropdownButtonWidget(
                      value: _selectedLevelAtHub,
                      text: 'Expense Category',
                      hintText: 'Select expense category',
                      onChanged: (value) {
                        setState(() {
                          _selectedLevelAtHub = value;
                        });
                      },
                      items: state.expenseCategories
                          .map((e) => DropdownMenuItem(
                                value: e.name,
                                child: Text(e.name),
                              ))
                          .toList(),
                      textSpanEnable: true,
                    ),
                    const VerticalSpace.xxSmall(),
                    CustomJobTextfield(
                      textInputAction: TextInputAction.done,
                      text: "Price",
                      focusNode: focusNode,
                      hintText: "Enter the price(£)",
                      controller: _priceController,
                      inputFormatters: [
                        CommaToDotTextInputFormatter(),
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const VerticalSpace.small(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Receipt",
                          style: context.textTheme.bodyLarge?.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        const VerticalSpace.small(),
                        InkWell(
                          child: Image.asset(
                            width: context.width,
                            "assets/images/fr_upload_image1.png",
                          ),
                          onTap: () {
                            _showImagePickerDialog(context);
                          },
                        ),
                      ],
                    ),
                    const VerticalSpace.small(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _imageFile == null
                            ? SizedBox(
                                height: context.dynamicHeight(0.15),
                                width: context.dynamicWidth(0.90),
                                child: CustomJobTextfield(
                                    controller: _reasonController,
                                    text:
                                        "If no receipt uploaded, provide reason why",
                                    hintText: "Enter text..."),
                              )
                            : Padding(
                                padding: context.paddingHorizontalDefault,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: context.dynamicHeight(0.15),
                                        width: context.dynamicWidth(0.35),
                                        decoration: BoxDecoration(
                                          color: context.theme.colorScheme
                                              .primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: FileImage(_imageFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color:
                                              context.theme.colorScheme.error,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _imageFile = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    const VerticalSpace.small(),
                    CustomAppButton(
                      text: "Save",
                      ontap: () {
                        if (_selectedLevelAtHub == null) {
                          BotToast.showText(
                              text:
                                  "Please select an expense category to proceed");
                          return;
                        }
                        if (_priceController.text.isEmpty ||
                            double.tryParse(_priceController.text) == null) {
                          BotToast.showText(text: "Please enter the price");
                          return;
                        }
                        if (_imageFile == null &&
                            _reasonController.text.isEmpty) {
                          BotToast.showText(
                              text:
                                  "Please upload a receipt or provide a reason why no receipt is uploaded");
                          return;
                        }
                        String? _currentJobId = "";
                        // ignore: unused_local_variable
                        if (ProductStateItems.hiveDatabaseManager
                                .getUserModel() !=
                            null) {
                          _currentJobId = ProductStateItems.hiveDatabaseManager
                              .getUserModel()!
                              .currentJobId
                              .toString();
                        }
                        context.read<JobExpenseBloc>().add(PostExpense(
                            ExpensePostModel(
                              jobId: _currentJobId != ""
                                  ? int.parse(_currentJobId)
                                  : widget.jobId,
                              reasonNoReceipt: _reasonController.text != ""
                                  ? _reasonController.text
                                  : null,
                              receipt: _imageFile,
                              categoryId: state.expenseCategories
                                  .firstWhere((element) =>
                                      element.name == _selectedLevelAtHub)
                                  .id,
                              price: double.parse(_priceController.text),
                            ),
                            false));
                      },
                    ),
                    const VerticalSpace.small(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.colorScheme.surface,
            ),
            width: context.dynamicWidth(0.98),
            height: context.dynamicHeight(0.38),
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Select an image picker method',
                    style: context.textTheme.headlineMedium?.copyWith(
                        color: context.theme.colorScheme.primary, fontSize: 20),
                  ),
                  Column(
                    children: [
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Open Camera",
                          containerColor: context.theme.colorScheme.surface,
                          ontap: () async {
                            context.pop();

                            await _getImage(ImageSource.camera);
                          }),
                      const VerticalSpace.xxSmall(),
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Pick From Gallery",
                          containerColor: context.theme.colorScheme.surface,
                          ontap: () async {
                            context.pop();
                            await _getImage(ImageSource.gallery);
                          }),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        'Cancel',
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.red),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomJobTextfield extends StatelessWidget {
  final String text;
  final String hintText;
  final Function(String)? onChanged;
  final IconButton? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(dynamic value)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double? height;
  final bool? expands;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  CustomJobTextfield({
    this.keyboardType,
    this.textInputAction,
    super.key,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    required this.text,
    required this.hintText,
    required this.controller,
    this.validator,
    this.height,
    this.inputFormatters,
    this.expands,
    this.focusNode,
  }) {
    controller.addListener(_upperTextFirst);
  }

  void _upperTextFirst() {
    String text = controller.text;
    if (text.isNotEmpty && text[0] != text[0].toUpperCase()) {
      controller.value = controller.value.copyWith(
        text: text[0].toUpperCase() + text.substring(1),
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 14, color: context.theme.colorScheme.primary),
                ),
                const Text("*",
                    style: TextStyle(
                      color: Color(0xFFDA0002),
                    ))
              ],
            ),
            SizedBox(height: context.dynamicHeight(0.01)),
            SizedBox(
              height: height ?? context.dynamicHeight(0.08),
              child: TextField(
                focusNode: focusNode,
                inputFormatters: inputFormatters,
                textInputAction: textInputAction,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.left,
                maxLines: null,
                expands: expands ?? false,
                keyboardType: keyboardType,
                controller: controller,
                onChanged: onChanged,
                obscureText: obscureText,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.theme.colorScheme.surface,
                  hintText: hintText,
                  isDense: true,
                  suffixIcon: suffixIcon,
                  hintStyle: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.onPrimary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CommaToDotTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(',', '.');
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}
