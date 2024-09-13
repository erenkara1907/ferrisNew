import 'package:bloc_test/bloc_test.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/expense/expense_service_mock.dart';
import 'mock/hive/database_cache_mock.dart';
import 'mock/hive/storage_cache_mock.dart';

void main() {
  late JobExpenseBloc jobExpenseBloc;

  setUp(() {
    jobExpenseBloc = JobExpenseBloc(
      ucGetJobExpense: ExpenseServiceMock(),
      hiveStorageManager: StorageCacheMock(),
      hiveDatabaseManager: DatabaseCacheMock(),
    );
  });

  blocTest<JobExpenseBloc, JobExpenseState>(
    'clear expense post',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const ClearExpensePost(),
    ),
    expect: () => [
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expenses', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'post expense',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      PostExpense(
          ExpensePostModel(jobId: 1, categoryId: 1, price: 20.0), false),
    ),
    expect: () => [
      isA<JobExpenseState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expenses', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'patch expense',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      PatchExpense(ExpensePatchModel(categoryId: 1, price: 20.0), false, 0),
    ),
    expect: () => [
      isA<JobExpenseState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expenses', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'get expense categories',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const GetExpenseCategories(),
    ),
    expect: () => [
      isA<JobExpenseState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobExpenseState>().having(
          (state) => state.expenseCategories, 'expense categories', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'get job expenses',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const GetJobExpenses(jobId: 1),
    ),
    expect: () => [
      isA<JobExpenseState>().having(
          (state) => state.status, 'status loading', ViewStatus.loading),
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'job expenses', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'set expense categories',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const SetExpenseCategories(),
    ),
    expect: () => [
      isA<JobExpenseState>().having(
          (state) => state.expenseCategories, 'expense categories', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'set expense list',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const SetExpenseList(),
    ),
    expect: () => [
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expense list', isNotNull),
    ],
  );

  blocTest<JobExpenseBloc, JobExpenseState>(
    'set expense post',
    build: () => jobExpenseBloc,
    act: (bloc) => bloc.add(
      const SetExpensePost(1),
    ),
    expect: () => [
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expense post empty', isEmpty),
      isA<JobExpenseState>()
          .having((state) => state.expenses, 'expense post', isNotNull),
    ],
  );
}
