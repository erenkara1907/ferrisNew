import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';

abstract interface class JobExpenseRepository {
  Future<Either<Failure, List<ExpensesResponseModelItem>>> jobExpenses({
    required int jobId,
  });

  Future<Either<Failure, ExpensesResponseModelItem>> postExpense({
    required ExpensePostModel data,
  });

  Future<Either<Failure, ExpensePatchResponseModel>> patchExpense({
    required ExpensePatchModel data,
  });

  Future<Either<Failure, List<ExpenseCategoriesResponseModelItem>>>
      getExpenseCategories();
}
