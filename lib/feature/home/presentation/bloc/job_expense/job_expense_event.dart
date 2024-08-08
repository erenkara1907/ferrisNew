part of 'job_expense_bloc.dart';

sealed class JobExpenseEvent extends Equatable {
  const JobExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetJobExpenses extends JobExpenseEvent {
  final int? expenseId;
  final int jobId;

  const GetJobExpenses({
    this.expenseId,
    required this.jobId,
  });

  @override
  List<Object> get props => [
        expenseId ?? 0,
        jobId,
      ];
}

class PostExpense extends JobExpenseEvent {
  final ExpensePostModel data;
  final bool isAsync;

  const PostExpense(this.data, this.isAsync);

  @override
  List<Object> get props => [data, isAsync];
}

class PatchExpense extends JobExpenseEvent {
  final ExpensePatchModel data;
  final bool isAsync;
  final int? index;
  const PatchExpense(this.data, this.isAsync, this.index);

  @override
  List<Object> get props => [data, isAsync];
}

class GetExpenseCategories extends JobExpenseEvent {
  const GetExpenseCategories();

  @override
  List<Object> get props => [];
}

class SetExpenseCategories extends JobExpenseEvent {
  const SetExpenseCategories();

  @override
  List<Object> get props => [];
}

class SetExpenseList extends JobExpenseEvent {
  const SetExpenseList();

  @override
  List<Object> get props => [];
}

class SetExpensePost extends JobExpenseEvent {
  final int jobId;
  const SetExpensePost(this.jobId);
}

class ClearExpensePost extends JobExpenseEvent {
  const ClearExpensePost();

  @override
  List<Object> get props => [];
}
