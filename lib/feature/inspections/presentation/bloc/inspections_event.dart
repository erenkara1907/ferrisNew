part of 'inspections_bloc.dart';

sealed class InspectionsEvent extends Equatable {
  const InspectionsEvent();

  @override
  List<Object> get props => [];
}

class GetJobInspections extends InspectionsEvent {
  final int jobId;
  final String? regnNumber;
  const GetJobInspections({
    required this.jobId,
    this.regnNumber,
  });
}

class ConditionsImagesEvent extends InspectionsEvent {
  final File conditionImage;
  const ConditionsImagesEvent({required this.conditionImage});
}

class SetEditDetails extends InspectionsEvent {
  final double odo;
  final int fuelLevel;
  const SetEditDetails({required this.fuelLevel, required this.odo});

  @override
  List<Object> get props => [odo, fuelLevel];
}

class GetJobInspectionsCheckList extends InspectionsEvent {
  final int inspectionId;
  const GetJobInspectionsCheckList({
    required this.inspectionId,
  });
}

class PatchJobInspectionsDamages extends InspectionsEvent {
  final InspectionDamagePatchModel data;
  final int? jobInspectionId;
  const PatchJobInspectionsDamages({
    required this.data,
    this.jobInspectionId,
  });
}

class PostJobInspectionsCheckList extends InspectionsEvent {
  final InspectionChecklistPostModel data;
  final bool isAsync;
  final bool isUpdate;
  final int? checklistId;
  const PostJobInspectionsCheckList(this.data, this.isAsync, this.isUpdate, this.checklistId);
}

class PostConditionImages extends InspectionsEvent {
  final List<ConditionImageResponseModel> dataList;
  final int? jobInspectionId;
  final bool isAsync;
  final List<File> imageFiles;

  const PostConditionImages({
    required this.dataList,
    this.jobInspectionId,
    required this.isAsync,
    required this.imageFiles,
  });
}

class PostConditionImagesRemote extends InspectionsEvent {
  final ConditionImageResponseModel conditionImage;
  final int? jobInspectionId;

  const PostConditionImagesRemote({
    required this.conditionImage,
    this.jobInspectionId,
  });
}

class DeleteConditionImage extends InspectionsEvent {
  final int imageId;
  final int jobInspectionId;
  final int index;
  final ConditionImageResponseModel model;

  const DeleteConditionImage(
    this.imageId,
    this.jobInspectionId,
    this.index,
    this.model,
  );
}

class DeleteRecordedDamage extends InspectionsEvent {
  final int damageId;
  final int jobInspectionId;
  final int combinationId;
  final int stateDamageId;
  final int repairId;
  final DamageResponseModel model;

  const DeleteRecordedDamage(this.damageId, this.jobInspectionId, this.combinationId,
      {required this.stateDamageId, required this.repairId, required this.model});
}

class DeleteRecordedDamageRemote extends InspectionsEvent {
  final int damageId;

  const DeleteRecordedDamageRemote(this.damageId);
}

class DeleteConditionImageRemote extends InspectionsEvent {
  final int conditionId;

  const DeleteConditionImageRemote(this.conditionId);
}

class UpdateDamageResponse extends InspectionsEvent {
  final List<DamageResponseModel> damages;

  const UpdateDamageResponse(this.damages);
}

class PostJobInspectionsDamages extends InspectionsEvent {
  final InspectionDamagePostModel data;
  final bool isAsync;
  final int? jobInspectionId;
  const PostJobInspectionsDamages({
    required this.data,
    required this.isAsync,
    this.jobInspectionId,
  });
}

class PostJobInspectionsDamagesRemote extends InspectionsEvent {
  final InspectionDamagePostModel data;
  final bool isAsync;
  final int? jobInspectionId;
  const PostJobInspectionsDamagesRemote({
    required this.data,
    required this.isAsync,
    this.jobInspectionId,
  });
}

class PostJobInspectionsDamagesControl extends InspectionsEvent {
  const PostJobInspectionsDamagesControl();
}

class PostJobInspectionsCustomerSign extends InspectionsEvent {
  final int jobInspectionId;
  final InspectionCustomerSignPostModel data;
  final InspectionInspectorSignPostModel? signData;
  final bool isAsync;

  const PostJobInspectionsCustomerSign({
    required this.jobInspectionId,
    required this.data,
    required this.isAsync,
    this.signData,
  });
}

class PostInspectionSign extends InspectionsEvent {
  final int jobInspectionId;
  final bool isAsync;
  final InspectionInspectorSignPostModel data;

  const PostInspectionSign({
    required this.jobInspectionId,
    required this.data,
    required this.isAsync,
  });
}

class InspectionsItemDetail extends InspectionsEvent {
  final double odoReading;
  final int fuelLevel;
  final int inspectionId;
  final bool isAsync;

  const InspectionsItemDetail({
    required this.odoReading,
    required this.fuelLevel,
    required this.inspectionId,
    required this.isAsync,
  });
}

class SetInspections extends InspectionsEvent {
  const SetInspections();
}

class SetItemCheckList extends InspectionsEvent {
  final ChecklistItemOption data;
  final int index;

  const SetItemCheckList({
    required this.data,
    required this.index,
  });
}

class GetInspectionsDamagesCategory extends InspectionsEvent {
  final int damageCategoryId;
  const GetInspectionsDamagesCategory(
    this.damageCategoryId,
  );
}

class GetInspectionsDamagesFailure extends InspectionsEvent {
  final int damageIssueId;
  final int damageCategoryId;
  final int damagePartId;
  final List<int> standarIds;
  const GetInspectionsDamagesFailure(
    this.damageIssueId, {
    required this.damageCategoryId,
    required this.damagePartId,
    required this.standarIds,
  });
}

class GetInspectionsDamagesIssue extends InspectionsEvent {
  final int damagePartId;
  final int damageCategoryId;
  final List<int> standarIds;
  const GetInspectionsDamagesIssue(
    this.damagePartId, {
    required this.damageCategoryId,
    required this.standarIds,
  });
}

class GetInspectionsDamagesPart extends InspectionsEvent {
  final int damageCategoryId;
  final List<int> standardIds;
  const GetInspectionsDamagesPart(
    this.damageCategoryId,
    this.standardIds,
  );
}

class GetInspectionsDamagesRepair extends InspectionsEvent {
  final int damageFailureId;
  final int damageCategoryId;
  final int damagePartId;
  final int damageIssueId;
  final List<int> standarIds;
  const GetInspectionsDamagesRepair(
    this.damageFailureId, {
    required this.damageCategoryId,
    required this.damagePartId,
    required this.standarIds,
    required this.damageIssueId,
  });
}

class GetInspectionsDamageCategories extends InspectionsEvent {
  // final int inspectionId;
  const GetInspectionsDamageCategories();
}

class GetInspectionsDamageAssets extends InspectionsEvent {
  final List<int> standardIds;
  const GetInspectionsDamageAssets({required this.standardIds});
}

class SetAllDamages extends InspectionsEvent {
  const SetAllDamages();
}

class CleanDamages extends InspectionsEvent {
  final bool isCategory;
  final bool isIssue;
  final bool isPart;

  final bool isFailure;
  const CleanDamages({this.isCategory = false, this.isIssue = false, this.isPart = false, this.isFailure = false});
}

class SetCustomerImage extends InspectionsEvent {
  final Uint8List image;
  final String name;
  const SetCustomerImage(this.image, this.name);
}

class SetDriverImage extends InspectionsEvent {
  final Uint8List image;
  const SetDriverImage(this.image);
}

class SetGetDamages extends InspectionsEvent {
  final int inspectionId;
  const SetGetDamages(this.inspectionId);
}

class SetGetConditionImages extends InspectionsEvent {
  final int inspectionId;
  const SetGetConditionImages(this.inspectionId);
}

class GetConditionOnlyImage extends InspectionsEvent {
  final int inspectionId;
  const GetConditionOnlyImage(this.inspectionId);
}

class SetLatLong extends InspectionsEvent {
  final String lat;
  final String long;
  const SetLatLong(this.lat, this.long);
}

class SetAddress extends InspectionsEvent {
  final String address;
  const SetAddress(this.address);
}

class RemoveConditionImage extends InspectionsEvent {
  final int id;
  const RemoveConditionImage(this.id);
}

class ClearState extends InspectionsEvent {
  const ClearState();
}

class SetInspectionDetailType extends InspectionsEvent {
  final int inspectionId;

  const SetInspectionDetailType(this.inspectionId);
}

class ClearInspection extends InspectionsEvent {
  const ClearInspection();
}

class ToggleButtonsEvent extends InspectionsEvent {}
