part of 'job_expense_bloc.dart';

final class JobExpenseState extends Equatable {
  const JobExpenseState({
    this.status,
    this.failure,
    this.expenses = const [],
    this.selectedExpense,
    this.expensePatchResponseModel,
    this.expenseCategories = const [],
    this.totalExpense = '',
    this.expensePostResponses = const [],
  });

  final ViewStatus? status;
  final Failure? failure;
  final List<ExpensesResponseModelItem?> expenses;
  final ExpensesResponseModelItem? selectedExpense;
  final ExpensePatchResponseModel? expensePatchResponseModel;
  final List<ExpenseCategoriesResponseModelItem> expenseCategories;
  final List<ExpensesResponseModelItem> expensePostResponses;
  final String totalExpense;

  @override
  List<Object?> get props => [
        status,
        failure,
        expenses,
        selectedExpense,
        expensePatchResponseModel,
        expenseCategories,
        totalExpense,
        expensePostResponses,
      ];

  JobExpenseState copyWith({
    ViewStatus? status,
    List<ExpensesResponseModelItem?>? expenses,
    ExpensesResponseModelItem? selectedExpense,
    ExpensePatchResponseModel? expensePatchResponseModel,
    List<ExpenseCategoriesResponseModelItem>? expenseCategories,
    List<ExpensesResponseModelItem>? expensePostResponses,
    Failure? failure,
    String? totalExpense,
  }) {
    return JobExpenseState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      totalExpense: totalExpense ?? this.totalExpense,
      expenses: expenses ?? this.expenses,
      selectedExpense: selectedExpense ?? this.selectedExpense,
      expensePatchResponseModel:
          expensePatchResponseModel ?? this.expensePatchResponseModel,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      expensePostResponses: expensePostResponses ?? this.expensePostResponses,
    );
  }
}
