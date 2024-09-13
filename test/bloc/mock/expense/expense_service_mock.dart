import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_expense.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:mockito/mockito.dart';

final class ExpenseServiceMock extends Mock implements UCGetJobExpense {
  @override
  Future<Either<Failure, List<ExpensesResponseModelItem>>> jobExpenses(
      {required int jobId}) {
    List<ExpensesResponseModelItem> r = [
      ExpensesResponseModelItem(
        id: 1,
        jobId: 1,
        price: 20.0,
        reasonNoReceipt: "reason no recipt",
        receiptPath: [],
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
      ),
      ExpensesResponseModelItem(
        id: 2,
        jobId: 1,
        price: 20.0,
        reasonNoReceipt: "reason no recipt",
        receiptPath: [],
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 2, name: "category 2"),
      ),
      ExpensesResponseModelItem(
        id: 3,
        jobId: 1,
        price: 20.0,
        reasonNoReceipt: "reason no recipt",
        receiptPath: [],
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 3, name: "category 3"),
      ),
    ];
    if (jobId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, ExpensesResponseModelItem>> postExpense(
      {required ExpensePostModel data}) {
    if (data.jobId == 1) {
      return Future.value(
        Right(
          ExpensesResponseModelItem(
            id: 3,
            jobId: 1,
            price: 20.0,
            reasonNoReceipt: "reason no recipt",
            receiptPath: [],
            categoryId:
                ExpenseCategoriesResponseModelItem(id: 3, name: "category 3"),
          ),
        ),
      );
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, ExpensePatchResponseModel>> patchExpense(
      {required ExpensePatchModel data}) {
    if (data.categoryId == 1) {
      return Future.value(
        Right(
          ExpensePatchResponseModel(
            oldExpense: ExpensesResponseModelItem(
              id: 1,
              jobId: 1,
              price: 20.0,
              reasonNoReceipt: "reason no recipt",
              receiptPath: [],
              categoryId:
                  ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
            ),
            newExpense: ExpensesResponseModelItem(
              id: 3,
              jobId: 1,
              price: 20.0,
              reasonNoReceipt: "reason no recipt",
              receiptPath: [],
              categoryId:
                  ExpenseCategoriesResponseModelItem(id: 3, name: "category 3"),
            ),
          ),
        ),
      );
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseCategoriesResponseModelItem>>>
      getExpenseCategories() {
    List<ExpenseCategoriesResponseModelItem> r = [
      ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
      ExpenseCategoriesResponseModelItem(id: 2, name: "category 2"),
      ExpenseCategoriesResponseModelItem(id: 3, name: "category 3"),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
