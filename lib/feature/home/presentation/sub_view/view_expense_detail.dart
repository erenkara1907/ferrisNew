import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/add_file_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewExpenseDetail extends StatefulWidget {
  final ExpensesResponseModelItem expense;
  final int index;
  const ViewExpenseDetail({super.key, required this.expense, required this.index});

  @override
  State<ViewExpenseDetail> createState() => _ViewExpenseDetailState();
}

class _ViewExpenseDetailState extends State<ViewExpenseDetail> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedLevelAtHub;
  File? _imageFile;
  String? filePath;
  bool? imageSelected = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Permission'),
              content:
                  const Text('This app needs camera access to take pictures. Please allow camera access in settings.'),
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
                    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
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
      final newFile = await file.copy('$documentPath/${path.basename(file.path)}');
      File compressedImage = await _resizeImage(newFile);

      setState(() {
        _imageFile = compressedImage;
        imageSelected = true;
      });
      _scrollToEnd();
    } else {}
  }

  void _scrollToEnd() {
    FocusScope.of(context).unfocus();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
  void initState() {
    _priceController.text = widget.expense.price!.toStringAsFixed(2);

    _reasonController.text = widget.expense.reasonNoReceipt ?? "";
    _selectedLevelAtHub = context
        .read<JobExpenseBloc>()
        .state
        .expenseCategories
        .where((element) => element.id == widget.expense.categoryId?.id)
        .map((category) => category.name)
        .firstOrNull;
    setFilePath();
    super.initState();
  }

  Future<void> setFilePath() async {
    final documentPath = (await getApplicationDocumentsDirectory()).path;

    setState(() {
      filePath = documentPath;
    });
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
            GetJobExpenses(jobId: widget.expense.jobId);
            showTopSnackBarFr(context, message: 'Expense updated successfully');
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.status == ViewStatus.loading) {
            _imageFile = null;
            _priceController.clear();
            _reasonController.clear();
            _selectedLevelAtHub = null;
            imageSelected = false;

            return const Scaffold(
              body: Center(
                child: LoadingProgress(),
              ),
            );
          }
          if (filePath.toString() == "" || filePath.toString() == "null") {
            return const Scaffold(
                body: Center(
              child: LoadingProgress(),
            ));
          }
          final pathImage = ProductStateItems.hiveStorageManager
                  .getPostExpenseSaveImage(price: widget.expense.price!, categoryId: widget.expense.categoryId!.id)
                  ?.receipt
                  ?.path ??
              "";
          if (pathImage != "") {
            int documentsIndex = pathImage.indexOf("Documents/");
            String result = pathImage.substring(documentsIndex + "Documents/".length);

            final path = '$filePath/$result';
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
                            'Expense Edit',
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
                        inputFormatters: [
                          CommaToDotTextInputFormatter(),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        text: "Price",
                        hintText: "Enter the price",
                        controller: _priceController,
                      ),
                      const VerticalSpace.small(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Receipt",
                            style: context.textTheme.bodyLarge
                                ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                          const VerticalSpace.small(),
                          InkWell(
                            child: const AddFileButton(fileCount: 1),
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
                          _imageFile == "" || widget.expense.receiptPath.isEmpty
                              ? SizedBox(
                                  height: context.dynamicHeight(0.15),
                                  width: context.dynamicWidth(0.90),
                                  child: CustomJobTextfield(
                                      controller: _reasonController,
                                      text: "If no receipt uploaded, provide reason why",
                                      hintText: "Enter text..."),
                                )
                              : widget.expense.receiptPath.isNotEmpty && _imageFile == null
                                  ? SizedBox(
                                      height: context.dynamicHeight(0.15),
                                      width: context.dynamicWidth(0.35),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            File(path),
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                  : Padding(
                                      padding: context.paddingHorizontalDefault,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              height: context.dynamicHeight(0.25),
                                              width: context.dynamicWidth(0.30),
                                              decoration: BoxDecoration(
                                                color: context.theme.colorScheme.primaryContainer,
                                                borderRadius: BorderRadius.circular(10),
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
                                                color: context.theme.colorScheme.error,
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
                        enabled: _selectedLevelAtHub != null,
                        text: "Update",
                        ontap: () async {
                          if (_selectedLevelAtHub == null) {
                            BotToast.showText(text: "Please select an expense category to proceed");
                            return;
                          }
                          if (_priceController.text.isEmpty || double.tryParse(_priceController.text) == null) {
                            BotToast.showText(text: "Please enter the price");
                            return;
                          }
                          if (_imageFile == null &&
                              _reasonController.text.isEmpty &&
                              widget.expense.receiptPath.isEmpty) {
                            BotToast.showText(
                                text: "Please upload a receipt or provide a reason why no receipt is uploaded");
                            return;
                          }
                          final selectedLevelAtHubOld = context
                              .read<JobExpenseBloc>()
                              .state
                              .expenseCategories
                              .where((element) => element.id == widget.expense.categoryId?.id)
                              .map((category) => category.name)
                              .firstOrNull;

                          if (selectedLevelAtHubOld == _selectedLevelAtHub &&
                              double.parse(_priceController.text) == widget.expense.price &&
                              imageSelected == false) {
                            BotToast.showText(text: "Please make a change");
                            return;
                          }
                          context.read<JobExpenseBloc>().add(PatchExpense(
                              ExpensePatchModel(
                                expenseId: widget.expense.id,
                                reasonNoReceipt: _reasonController.text != ""
                                    ? _reasonController.text
                                    : widget.expense.reasonNoReceipt,
                                receipt: _imageFile ?? File(path),
                                categoryId: state.expenseCategories
                                    .firstWhere((element) => element.name == _selectedLevelAtHub)
                                    .id,
                                price: double.parse(_priceController.text),
                              ),
                              false,
                              widget.index));
                          context.pop();
                        },
                      ),
                      const VerticalSpace.small(),
                    ],
                  ),
                ),
              ),
            );
          }
          _reasonController.text = widget.expense.reasonNoReceipt ?? "";
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
                          'Expense Edit',
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
                      inputFormatters: [
                        CommaToDotTextInputFormatter(),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      text: "Price",
                      hintText: "Enter the price",
                      controller: _priceController,
                    ),
                    const VerticalSpace.small(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Receipt",
                          style: context.textTheme.bodyLarge
                              ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                        ),
                        const VerticalSpace.small(),
                        InkWell(
                          child: const AddFileButton(fileCount: 1),
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
                        _imageFile == null && widget.expense.receiptPath.isEmpty
                            ? SizedBox(
                                height: context.dynamicHeight(0.15),
                                width: context.dynamicWidth(0.90),
                                child: CustomJobTextfield(
                                    controller: _reasonController,
                                    text: "If no receipt uploaded, provide reason why",
                                    hintText: "Enter text..."),
                              )
                            : widget.expense.receiptPath.isNotEmpty && _imageFile == null
                                ? const SizedBox()
                                : Padding(
                                    padding: context.paddingHorizontalDefault,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: context.dynamicHeight(0.25),
                                            width: context.dynamicWidth(0.30),
                                            decoration: BoxDecoration(
                                              color: context.theme.colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(10),
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
                                              color: context.theme.colorScheme.error,
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
                      enabled: _selectedLevelAtHub != null,
                      text: "Update",
                      ontap: () async {
                        if (_selectedLevelAtHub == null) {
                          BotToast.showText(text: "Please select an expense category to proceed");
                          return;
                        }
                        if (_priceController.text.isEmpty || double.tryParse(_priceController.text) == null) {
                          BotToast.showText(text: "Please enter the price");
                          return;
                        }
                        if (_imageFile == null &&
                            _reasonController.text.isEmpty &&
                            widget.expense.receiptPath.isEmpty) {
                          BotToast.showText(
                              text: "Please upload a receipt or provide a reason why no receipt is uploaded");
                          return;
                        }
                        final selectedLevelAtHubOld = context
                            .read<JobExpenseBloc>()
                            .state
                            .expenseCategories
                            .where((element) => element.id == widget.expense.categoryId?.id)
                            .map((category) => category.name)
                            .firstOrNull;

                        if (selectedLevelAtHubOld == _selectedLevelAtHub &&
                            double.parse(_priceController.text) == widget.expense.price &&
                            _reasonController.text == widget.expense.reasonNoReceipt &&
                            imageSelected == false) {
                          BotToast.showText(text: "Please make a change");
                          return;
                        }
                        context.read<JobExpenseBloc>().add(PatchExpense(
                            ExpensePatchModel(
                              expenseId: widget.expense.id,
                              reasonNoReceipt: _reasonController.text != ""
                                  ? _reasonController.text
                                  : widget.expense.reasonNoReceipt,
                              receipt: _imageFile,
                              categoryId: state.expenseCategories
                                  .firstWhere((element) => element.name == _selectedLevelAtHub)
                                  .id,
                              price: double.parse(_priceController.text),
                            ),
                            false,
                            widget.index));
                        context.pop();
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
              color: context.theme.colorScheme.onSurfaceVariant,
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
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: context.theme.colorScheme.primary, fontSize: 20),
                  ),
                  Column(
                    children: [
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Open Camera",
                          containerColor: context.theme.colorScheme.onSurfaceVariant,
                          ontap: () async {
                            Navigator.of(context).pop();

                            await _getImage(ImageSource.camera);
                          }),
                      const VerticalSpace.xxSmall(),
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Pick From Gallery",
                          containerColor: context.theme.colorScheme.onSurfaceVariant,
                          ontap: () async {
                            Navigator.of(context).pop();

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
                        style: context.textTheme.bodyLarge?.copyWith(color: Colors.red),
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
  List<TextInputFormatter>? inputFormatters;

  CustomJobTextfield({
    super.key,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    required this.text,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
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
                  style: TextStyle(fontSize: 14, color: context.theme.colorScheme.primary),
                ),
                const Text("*",
                    style: TextStyle(
                      color: Color(0xFFDA0002),
                    ))
              ],
            ),
            SizedBox(height: context.dynamicHeight(0.01)),
            SizedBox(
              height: context.dynamicHeight(0.08),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: keyboardType,
                controller: controller,
                onChanged: onChanged,
                obscureText: obscureText,
                inputFormatters: inputFormatters,
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
