part of hive_storage_manager;

mixin ExpenseOperationsMixin {
  static const String _boxNameExpenses = 'local_expenses';

  /// LazyBox instance for the expenses box.
  LazyBox<ExpensesResponseModelItem>? _expenseBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<ExpensesResponseModelItem>> get _expenseBox async {
    return _expenseBoxInstance ??=
        await Hive.openLazyBox<ExpensesResponseModelItem>(_boxNameExpenses);
  }

  /// Adds an expense to the expenses box. replace, if the expense already
  /// exists. returns true if the expense already exists and replaces.
  Future<bool> addExpense(List<ExpensesResponseModelItem> expense) async {
    final box = await _expenseBox;
    try {
      await box.clear();
      for (var item in expense) {
        if (box.containsKey(item.id)) {
          await box.delete(item.id);
        }
        await box.put(item.id, item);
      }
      return true;
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return false;
    }
  }

  Future<List<ExpensesResponseModelItem?>> getExpense() async {
    final box = await _expenseBox;
    final keys = box.keys.toList();
    final List<Future<ExpensesResponseModelItem?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  Future<ExpensesResponseModelItem?> setExpenseById(
      ExpensesResponseModelItem expense) async {
    final box = await _expenseBox;
    try {
      await box.put(expense.id, expense);
      return expense;
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return null;
    }
  }

  Future<ExpensesResponseModelItem?> setExpenseUpdateById(
      ExpensesResponseModelItem expense, int id) async {
    final box = await _expenseBox;
    try {
      await box.put(expense.id, expense);
      return expense;
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return null;
    }
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteExpenses() async {
    final box = await _expenseBox;
    await box.clear();
  }
}
