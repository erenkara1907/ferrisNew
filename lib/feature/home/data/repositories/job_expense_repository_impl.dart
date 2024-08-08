import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_expense_datasource.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_expense_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:flutter/material.dart';

final class JobExpenseRepositoryImpl implements JobExpenseRepository {
  JobExpenseRepositoryImpl({required JobExpenseRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobExpenseRemoteDataSource _dataSource;
  @override
  Future<Either<Failure, List<ExpensesResponseModelItem>>> jobExpenses({
    required int jobId,
  }) async {
    try {
      final response = await _dataSource.jobExpenses(jobId: jobId);
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ExpensesResponseModelItem>> postExpense({
    required ExpensePostModel data,
  }) async {
    try {
      final response = await _dataSource.postExpense(
        data: data,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ExpensePatchResponseModel>> patchExpense({
    required ExpensePatchModel data,
  }) async {
    try {
      final response = await _dataSource.patchExpense(
        data: data,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExpenseCategoriesResponseModelItem>>>
      getExpenseCategories() async {
    try {
      final response = await _dataSource.getExpenseCategories();
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }
}
