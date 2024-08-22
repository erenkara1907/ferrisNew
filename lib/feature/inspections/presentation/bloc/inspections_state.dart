part of 'inspections_bloc.dart';

final class InspectionsState extends Equatable {
  const InspectionsState({
    this.inspectionStatus,
    this.status,
    this.failure,
    this.checklists = const [],
    this.inspections = const [],
    this.inspectionAbortTypes = const [],
    this.isSetInspection = false,
    this.selectedChecklist = const [],
    this.getDamageCategoriesResponse = const [],
    this.getDamageFailuresResponse = const [],
    this.getDamageIssuesResponse = const [],
    this.getDamagePartsResponse = const [],
    this.getDamageRepairsResponse = const [],
    this.selectedDamageCategory,
    this.selectedDamageFailure,
    this.selectedDamageIssue,
    this.selectedDamagePart,
    this.selectedDamageRepair,
    this.imageCustamerFile,
    this.imageDriverFile,
    this.getDamageAssetsResponse = const [],
    this.imageCustamerName,
    this.damageResponse = const [],
    this.conditionImageResponse = const [],
    this.lat = '',
    this.long = '',
    this.address = '',
    this.isSigned = false,
    this.fuelLevel = 0,
    this.odo = 0.0,
    this.conditionImages = const [],
    this.contextImage = '',
    this.damageImage = '',
    this.areButtonsVisible = false,
    this.damageCategoryId = 1,
    this.damagePartId = 1,
    this.damageIssueId = 1,
    this.isError = false,
    this.gradeId = "",
  });

  final ViewStatus? status;
  final ViewStatus? inspectionStatus;
  final Failure? failure;
  final List<ChecklistResponseModelItem> checklists;
  final List<JobInspectionResponseModelItem?> inspections;
  final List<JobInspectionAbortTypeItem> inspectionAbortTypes;
  final bool isSetInspection;
  final List<ChecklistItemOption> selectedChecklist;
  final List<Categories?> getDamageCategoriesResponse;
  final List<DamageAssetsModel?> getDamageAssetsResponse;
  final List<Failures> getDamageFailuresResponse;
  final List<Issues> getDamageIssuesResponse;
  final List<Parts> getDamagePartsResponse;
  final List<Repairs> getDamageRepairsResponse;
  final DamagesCategory? selectedDamageCategory;
  final DamagesFailure? selectedDamageFailure;
  final DamagesIssue? selectedDamageIssue;
  final DamagesPart? selectedDamagePart;
  final DamagesRepair? selectedDamageRepair;
  final File? imageCustamerFile;
  final String? imageCustamerName;
  final File? imageDriverFile;
  final List<DamageResponseModel> damageResponse;
  final List<ConditionImageResponseModel> conditionImageResponse;
  final String lat;
  final String long;
  final String address;
  final bool isSigned;
  final int fuelLevel;
  final double odo;
  final List<File> conditionImages;
  final String contextImage;
  final String damageImage;
  final bool areButtonsVisible;
  final int damageCategoryId;
  final int damagePartId;
  final int damageIssueId;
  final bool isError;
  final String gradeId;

  @override
  List<Object?> get props => [
        inspectionStatus,
        status,
        failure,
        checklists,
        gradeId,
        inspections,
        inspectionAbortTypes,
        isSetInspection,
        selectedChecklist,
        damageCategoryId,
        damagePartId,
        getDamageCategoriesResponse,
        getDamageAssetsResponse,
        getDamageFailuresResponse,
        getDamageIssuesResponse,
        getDamagePartsResponse,
        getDamageRepairsResponse,
        selectedDamageCategory,
        selectedDamageFailure,
        selectedDamageIssue,
        isError,
        selectedDamagePart,
        areButtonsVisible,
        selectedDamageRepair,
        imageCustamerFile,
        imageDriverFile,
        imageCustamerName,
        damageResponse,
        conditionImageResponse,
        lat,
        long,
        address,
        isSigned,
        fuelLevel,
        odo,
        conditionImages,
        contextImage,
        damageImage,
      ];

  InspectionsState copyWith({
    ViewStatus? status,
    Failure? failure,
    List<ChecklistResponseModelItem>? checklists,
    List<JobInspectionResponseModelItem?>? inspections,
    List<JobInspectionAbortTypeItem>? inspectionAbortTypes,
    bool? isSetInspection,
    List<ChecklistItemOption>? selectedChecklist,
    List<Categories?>? getDamageCategoriesResponse,
    List<DamageAssetsModel?>? getDamageAssetsResponse,
    List<Failures>? getDamageFailuresResponse,
    List<Issues>? getDamageIssuesResponse,
    List<Parts>? getDamagePartsResponse,
    List<Repairs>? getDamageRepairsResponse,
    DamagesCategory? selectedDamageCategory,
    DamagesFailure? selectedDamageFailure,
    DamagesIssue? selectedDamageIssue,
    DamagesPart? selectedDamagePart,
    DamagesRepair? selectedDamageRepair,
    File? imageCustamerFile,
    File? imageDriverFile,
    String? imageCustamerName,
    List<DamageResponseModel>? damageResponse,
    List<ConditionImageResponseModel>? conditionImageResponse,
    String? lat,
    String? long,
    String? address,
    bool? isSigned,
    int? fuelLevel,
    double? odo,
    List<File>? conditionImages,
    String? contextImage,
    String? damageImage,
    ViewStatus? inspectionStatus,
    bool? areButtonsVisible,
    int? damageCategoryId,
    int? damagePartId,
    int? damageIssueId,
    bool? isError,
    String? gradeId,
  }) {
    return InspectionsState(
      status: status ?? this.status,
      gradeId: gradeId ?? this.gradeId,
      isError: isError ?? this.isError,
      damageCategoryId: damageCategoryId ?? this.damageCategoryId,
      damagePartId: damagePartId ?? this.damagePartId,
      damageIssueId: damageIssueId ?? this.damageIssueId,
      failure: failure ?? this.failure,
      checklists: checklists ?? this.checklists,
      areButtonsVisible: areButtonsVisible ?? this.areButtonsVisible,
      inspections: inspections ?? this.inspections,
      imageCustamerFile: imageCustamerFile ?? this.imageCustamerFile,
      imageDriverFile: imageDriverFile ?? this.imageDriverFile,
      inspectionAbortTypes: inspectionAbortTypes ?? this.inspectionAbortTypes,
      isSetInspection: isSetInspection ?? this.isSetInspection,
      selectedChecklist: selectedChecklist ?? this.selectedChecklist,
      imageCustamerName: imageCustamerName ?? this.imageCustamerName,
      getDamageCategoriesResponse:
          getDamageCategoriesResponse ?? this.getDamageCategoriesResponse,
      getDamageAssetsResponse:
          getDamageAssetsResponse ?? this.getDamageAssetsResponse,
      getDamageFailuresResponse:
          getDamageFailuresResponse ?? this.getDamageFailuresResponse,
      getDamageIssuesResponse:
          getDamageIssuesResponse ?? this.getDamageIssuesResponse,
      getDamagePartsResponse:
          getDamagePartsResponse ?? this.getDamagePartsResponse,
      getDamageRepairsResponse:
          getDamageRepairsResponse ?? this.getDamageRepairsResponse,
      damageResponse: damageResponse ?? this.damageResponse,
      selectedDamageCategory:
          selectedDamageCategory ?? this.selectedDamageCategory,
      selectedDamageFailure:
          selectedDamageFailure ?? this.selectedDamageFailure,
      selectedDamageIssue: selectedDamageIssue ?? this.selectedDamageIssue,
      selectedDamagePart: selectedDamagePart ?? this.selectedDamagePart,
      selectedDamageRepair: selectedDamageRepair ?? this.selectedDamageRepair,
      conditionImageResponse:
          conditionImageResponse ?? this.conditionImageResponse,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      address: address ?? this.address,
      isSigned: isSigned ?? this.isSigned,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      odo: odo ?? this.odo,
      conditionImages: conditionImages ?? this.conditionImages,
      contextImage: contextImage ?? this.contextImage,
      damageImage: damageImage ?? this.damageImage,
      inspectionStatus: inspectionStatus ?? this.inspectionStatus,
    );
  }
}
