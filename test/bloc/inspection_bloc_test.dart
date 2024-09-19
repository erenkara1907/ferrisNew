import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/hive/database_cache_mock.dart';
import 'mock/hive/storage_cache_mock.dart';
import 'mock/inspection/inspection_checklist_service_mock.dart';
import 'mock/inspection/inspection_condition_images_service_mock.dart';
import 'mock/inspection/inspection_damage_service_mock.dart';
import 'mock/inspection/inspection_service_mock.dart';
import 'mock/inspection/inspection_sign_service_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late InspectionsBloc inspectionsBloc;

  setUp(() {
    inspectionsBloc = InspectionsBloc(
      ucGetJobInspections: InspectionServiceMock(),
      ucGetJobInspectionsSign: InspectionSignServiceMock(),
      ucGetJobInspectionsDamages: InspectionDamageServiceMock(),
      ucGetJobInspectionsCheckList: InspectionChecklistServiceMock(),
      ucGetJobInspectionsConditionImages: InspectionConditionImagesServiceMock(),
      hiveDatabaseManager: DatabaseCacheMock(),
      hiveStorageManager: StorageCacheMock(),
    );
  });

  blocTest<InspectionsBloc, InspectionsState>(
    'toggle button',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      ToggleButtonsEvent(),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.areButtonsVisible,
        'button visible',
        true,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set edit details',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const SetEditDetails(fuelLevel: 1, odo: 1.0),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.fuelLevel,
        'fuel level',
        isNotNull,
      ),
    ],
  );

  //TODO: Change state to event
  blocTest<InspectionsBloc, InspectionsState>(
    'condition images',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      ConditionsImagesEvent(conditionImage: File("")),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.conditionImages,
        'condition images',
        isNotNull,
      ),
    ],
  );

  //TODO: Add dateTime
  blocTest<InspectionsBloc, InspectionsState>(
    'get job inspections',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetJobInspections(jobId: 1, regnNumber: "1"),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.inspections,
        'inspections',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get job inspection checklist',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetJobInspectionsCheckList(inspectionId: 1),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.checklists,
        'checklists',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'post job inspection checklist',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      PostJobInspectionsCheckList(
        InspectionChecklistPostModel(
          jobInspectionId: 1,
          inflatorKit: 1,
          evCable: 1,
          jack: 1,
          spareWheel: 1,
          gelCompressorKit: 1,
          thirteenAmpEvChargingCable: 1,
          hvChargingCable: 1,
          spareKey: 1,
          masterKey: 1,
        ),
        false,
        false,
        1,
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.status,
        'status success',
        ViewStatus.success,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'post condition image',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      PostConditionImages(
        dataList: [ConditionImageResponseModel(jobInspectionId: 1)],
        isAsync: false,
        imageFiles: const [],
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.conditionImageResponse,
        'condition images',
        isNotNull,
      ),
    ],
  );

  //TODO: Try again
  blocTest<InspectionsBloc, InspectionsState>(
    'delete condition image',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      DeleteConditionImage(
        1,
        1,
        0,
        ConditionImageResponseModel(jobInspectionId: 1),
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.conditionImageResponse,
        'condition images delete',
        isNotNull,
      ),
    ],
  );

  //TODO: Try again
  blocTest<InspectionsBloc, InspectionsState>(
    'delete recorded damage',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      DeleteRecordedDamage(
        1,
        1,
        1,
        stateDamageId: 1,
        repairId: 1,
        model: DamageResponseModel(
          id: 1,
          jobInspectionId: 1,
          categoryId: DamagesCategory(id: 1, name: "category 1"),
          partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
          issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
          failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
          repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
        ),
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.status,
        'status success',
        ViewStatus.success,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'update damage',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      UpdateDamageResponse([
        DamageResponseModel(
          id: 1,
          jobInspectionId: 1,
          categoryId: DamagesCategory(id: 1, name: "category 1"),
          partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
          issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
          failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
          repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
        ),
      ]),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.damageResponse,
        'damage response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'post job inspection damage control',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const PostJobInspectionsDamagesControl(),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.isError,
        'is Error',
        true,
      ),
    ],
  );

  //TODO: Try again
  blocTest<InspectionsBloc, InspectionsState>(
    'post job inspection damage',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      PostJobInspectionsDamages(
        isAsync: false,
        data: InspectionDamagePostModel(
          jobInspectionId: 1,
          categoryId: 1,
          partId: 1,
          issueId: 1,
          failureId: 1,
          repairId: 1,
          damageId: 1,
        ),
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.damageResponse,
        'damage response post',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'patch job inspection damage',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(PatchJobInspectionsDamages(
      data: InspectionDamagePatchModel(),
    )),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.damageResponse,
        'damage response patch',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'post job inspections customer sign',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      PostJobInspectionsCustomerSign(
        isAsync: false,
        jobInspectionId: 1,
        data: InspectionCustomerSignPostModel(
          customerSignatureImg: File("path"),
          customerSignerName: "test",
          customerSignLatitude: "20.0",
          customerSignLongitude: "20.0",
          date: "1",
        ),
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'post job inspection sign',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(PostInspectionSign(
      isAsync: false,
      jobInspectionId: 1,
      data: InspectionInspectorSignPostModel(
        inspectorSignatureImg: File("path"),
        inspectorSignerName: "test",
        inspectorSignLatitude: "20.0",
        inspectorSignLongitude: "20.0",
        date: "1",
      ),
    )),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.isSigned,
        'is signed',
        true,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'inspection item detail',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const InspectionsItemDetail(odoReading: 10.0, fuelLevel: 10, inspectionId: 1, isAsync: false),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.odo,
        'odo',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set inspections',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(const SetInspections()),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.inspections,
        'setted inspections',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get damage failures',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetInspectionsDamagesFailure(
        1,
        damageCategoryId: 1,
        damagePartId: 1,
        standarIds: [1],
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.getDamageFailuresResponse,
        'damage failure response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get damage issues',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetInspectionsDamagesIssue(
        1,
        damageCategoryId: 1,
        standarIds: [1],
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.getDamageIssuesResponse,
        'damage issue response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get damage parts',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetInspectionsDamagesPart(
        1,
        [1],
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.getDamagePartsResponse,
        'damage part response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get damage repairs',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetInspectionsDamagesRepair(
        1,
        damageCategoryId: 1,
        damagePartId: 1,
        standarIds: [1],
        damageIssueId: 1,
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.getDamageRepairsResponse,
        'damage repair response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'get damage category',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const GetInspectionsDamageAssets(
        standardIds: [1],
      ),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.getDamageCategoriesResponse,
        'damage category response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set get damages',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const SetGetDamages(1),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status loading',
        ViewStatus.loading,
      ),
      isA<InspectionsState>().having(
        (state) => state.damageResponse,
        'damage get response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set get condition images',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const SetGetConditionImages(1),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.conditionImageResponse,
        'condition image get response',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set lat long',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const SetLatLong("10.0", "20.0"),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.lat,
        'added lat',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'set address',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const SetAddress("110 address"),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.address,
        'added address',
        isNotNull,
      ),
    ],
  );

  blocTest<InspectionsBloc, InspectionsState>(
    'clear state',
    build: () => inspectionsBloc,
    act: (bloc) => bloc.add(
      const ClearState(),
    ),
    expect: () => [
      isA<InspectionsState>().having(
        (state) => state.status,
        'status',
        null,
      ),
    ],
  );
}
