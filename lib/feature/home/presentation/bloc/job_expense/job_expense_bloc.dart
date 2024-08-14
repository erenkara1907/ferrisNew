import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_expense.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';

part 'job_expense_event.dart';
part 'job_expense_state.dart';

class JobExpenseBloc extends Bloc<JobExpenseEvent, JobExpenseState> {
  JobExpenseBloc({
    required UCGetJobExpense ucGetJobExpense,
  })  : _ucGetJobExpense = ucGetJobExpense,
        super(const JobExpenseState()) {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    on<GetJobExpenses>(_onGetJobExpenses);
    on<PostExpense>(_onPostExpense);
    on<PatchExpense>(_onPatchExpense);
    on<GetExpenseCategories>(_onGetExpenseCategories);
    on<SetExpenseCategories>(_onSetExpenseCategories);
    on<SetExpenseList>(_onSetExpenseList);
    on<SetExpensePost>(_onSetExpensePost);
    on<ClearExpensePost>(_clearExpensePost);
  }

  final UCGetJobExpense _ucGetJobExpense;
  late final HiveStorageManager _hiveStorageManager;

  Future<void> _clearExpensePost(
      ClearExpensePost event, Emitter<JobExpenseState> emit) async {
    final data = await _hiveStorageManager.getExpense();
    emit(state.copyWith(
      expenses: data,
      totalExpense: data
          .fold(
              0.0, (previousValue, element) => previousValue + element!.price!)
          .toString(),
    ));
  }

  Future<void> _onPostExpense(
      PostExpense event, Emitter<JobExpenseState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();

    if (result) {
      final result = await _ucGetJobExpense.postExpense(
        data: event.data,
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
          if (event.isAsync) {
            add(GetJobExpenses(jobId: event.data.jobId));

            return;
          }
          // print("Receipt: ${event.data.receipt}");
          if (event.data.receipt != null) {
            _hiveStorageManager.addPostExpenseSaveImage(event.data);
          }

          _hiveStorageManager.setExpenseById(data);

          final expenses = state.expenses;
          if (expenses.isEmpty) {
            emit(state.copyWith(
                status: ViewStatus.success,
                expenses: [data, ...expenses],
                totalExpense: data.price.toString()));
            return;
          }

          emit(state.copyWith(
            status: ViewStatus.success,
            expenses: [data, ...expenses],
            totalExpense: (double.parse(state.totalExpense) +
                    double.parse(data.price.toString()))
                .toString(),
          ));
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setJobExpenseAsync(event.data);
      if (event.data.receipt != null) {
        _hiveStorageManager.addPostExpenseSaveImage(event.data);
      }
      final categoryName = state.expenseCategories
          .firstWhere((element) => element.id == event.data.categoryId)
          .name;
      final data = ExpensesResponseModelItem(
        jobId: event.data.jobId,
        id: Random().nextInt(1000),
        price: event.data.price,
        categoryId: ExpenseCategoriesResponseModelItem(
            id: event.data.categoryId, name: categoryName),
        reasonNoReceipt: event.data.reasonNoReceipt ?? "",
        receiptPath:
            event.data.receipt != null ? [event.data.receipt!.path] : [],
      );

      _hiveStorageManager.setExpenseById(data);

      final total = (double.parse(state.totalExpense) +
              double.parse(data.price.toString()))
          .toString();
      // print("Total: $total");

      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        status: ViewStatus.success,
        expenses: [data, ...state.expenses],
        totalExpense: total,
      ));
    }
  }

  Future<void> _onPatchExpense(
      PatchExpense event, Emitter<JobExpenseState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobExpense.patchExpense(
        data: event.data,
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
          if (event.isAsync) {
            add(GetJobExpenses(
                jobId: int.parse(ProductStateItems.hiveDatabaseManager
                        .getUserModel()
                        ?.currentJobId ??
                    "")));
            return;
          }
          final expenses = state.expenses;

          _hiveStorageManager.setExpenseUpdateById(
              data.newExpense, data.oldExpense.id);

          final model = ExpensePostModel(
              jobId: int.parse(ProductStateItems.hiveDatabaseManager
                      .getUserModel()
                      ?.currentJobId ??
                  ""),
              categoryId: event.data.categoryId ?? 0,
              price: event.data.price ?? 0,
              reasonNoReceipt: event.data.reasonNoReceipt ??
                  _hiveStorageManager
                      .getPostExpenseSaveImage(
                        price: event.data.price ?? 0,
                        categoryId: event.data.categoryId ?? 0,
                      )
                      ?.reasonNoReceipt,
              receipt: event.data.receipt ??
                  _hiveStorageManager
                      .getPostExpenseSaveImage(
                        price: event.data.price ?? 0,
                        categoryId: event.data.categoryId ?? 0,
                      )
                      ?.receipt);
          _hiveStorageManager.updateLastPostExpenseSaveImage(
              oldCategoryId: data.oldExpense.categoryId!.id,
              oldPrice: data.oldExpense.price ?? 0.0,
              newExpense: model);
          expenses.removeWhere((element) => element?.id == data.oldExpense.id);
          expenses.add(data.newExpense);

          final totalExpense = expenses.fold(
              0,
              (previousValue, element) =>
                  previousValue + element!.price!.toInt());
          emit(state.copyWith(
            status: ViewStatus.success,
            expenses: expenses,
            totalExpense: totalExpense.toString(),
          ));
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      final model = ExpensePostModel(
          jobId: int.parse(ProductStateItems.hiveDatabaseManager
                  .getUserModel()
                  ?.currentJobId ??
              ""),
          categoryId: event.data.categoryId ?? 0,
          price: event.data.price ?? 0,
          reasonNoReceipt: event.data.reasonNoReceipt,
          receipt: event.data.receipt);

      await Future.delayed(const Duration(seconds: 1));
      final expenses = state.expenses;

      final ExpensesResponseModelItem? category = state.expenses
          .firstWhere((element) => element?.id == event.data.expenseId);
      if (category != null) {
        _hiveStorageManager.setJobExpensePatchAsync(event.data);
        _hiveStorageManager.updateJobExpenseAsync(model, (model) => true);
      } else {
        _hiveStorageManager.setJobExpensePatchAsync(event.data);
      }
      final categoryName = state.expenseCategories
          .firstWhere((element) => element.id == event.data.categoryId)
          .name;
      final data = ExpensesResponseModelItem(
        jobId: int.parse(ProductStateItems.hiveDatabaseManager
                .getUserModel()
                ?.currentJobId ??
            ""),
        id: event.data.expenseId ?? 0,
        price: event.data.price,
        categoryId: ExpenseCategoriesResponseModelItem(
            id: event.data.categoryId ?? 0, name: categoryName),
        reasonNoReceipt: event.data.reasonNoReceipt ?? "",
        receiptPath:
            event.data.receipt != null ? [event.data.receipt!.path] : [],
      );

      final oldExpense = state.expenses
          .firstWhere((element) => element?.id == event.data.expenseId);

      _hiveStorageManager.updateLastPostExpenseSaveImage(
          oldCategoryId: oldExpense?.categoryId?.id ?? 0,
          oldPrice: oldExpense?.price ?? 0.0,
          newExpense: model);

      expenses.removeWhere((element) => oldExpense == element);

      expenses.add(data);

      _hiveStorageManager.setExpenseUpdateById(data, oldExpense!.id);

      final totalExpense = expenses.fold(0,
          (previousValue, element) => previousValue + element!.price!.toInt());
      emit(state.copyWith(
        status: ViewStatus.success,
        expenses: expenses,
        totalExpense: totalExpense.toString(),
      ));
    }
  }

  Future<void> _onGetExpenseCategories(
      GetExpenseCategories event, Emitter<JobExpenseState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobExpense.getExpenseCategories();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
      (data) {
        _hiveStorageManager.setExpenseCategories(data);
        emit(state.copyWith(
            status: ViewStatus.success, expenseCategories: data));
      },
    );
  }

  Future<void> _onGetJobExpenses(
      GetJobExpenses event, Emitter<JobExpenseState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, expenses: []));

    try {
      // Fetch expenses from the cache
      final cachedExpenses = await _hiveStorageManager.getJobExpenseAsync();
      final resultHasNetwork = await hasNetwork();

      if (resultHasNetwork) {
        final result = await _ucGetJobExpense.jobExpenses(jobId: event.jobId);
        result.fold(
          (failure) {
            emit(state.copyWith(status: ViewStatus.failure, failure: failure));
          },
          (data) async {
            print("EXPENSES : $data");
            if (cachedExpenses.isEmpty) {
              _hiveStorageManager.deleteExpenses();
              _hiveStorageManager.addExpense(data);
            }
            try {
              final totalExpense = data.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.price!.toInt());
              emit(state.copyWith(
                status: ViewStatus.success,
                expenses: data,
                totalExpense: totalExpense.toString(),
              ));
            } catch (e) {
              print("Error: $e");
              emit(state.copyWith(
                status: ViewStatus.failure,
              ));
            }
          },
        );
      } else {
        emit(state.copyWith(
          status: ViewStatus.success,
        ));
      }
    } catch (error) {
      // Handle any errors that may occur during the process
      emit(state.copyWith(
        status: ViewStatus.failure,
      ));
    }
  }

  Future<void> _onSetExpenseCategories(
      SetExpenseCategories event, Emitter<JobExpenseState> emit) async {
    final data = await _hiveStorageManager.getExpenseCategories();
    emit(state.copyWith(expenseCategories: data));
  }

  Future<void> _onSetExpenseList(
      SetExpenseList event, Emitter<JobExpenseState> emit) async {
    final data = await _hiveStorageManager.getExpense();

    emit(state.copyWith(expenses: data));
  }

  FutureOr<void> _onSetExpensePost(
      SetExpensePost event, Emitter<JobExpenseState> emit) async {
    emit(state.copyWith(expenses: [], totalExpense: "0.0"));
    final data = await _hiveStorageManager.getExpense();

    emit(state.copyWith(
      expenses: data,
      totalExpense: data
          .fold(
              0.0, (previousValue, element) => previousValue + element!.price!)
          .toString(),
    ));
  }
}
