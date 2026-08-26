import 'package:amanah/core/providers.dart';
import 'package:amanah/features/expenses/data/expense_repository.dart';
import 'package:amanah/features/expenses/data/models/expense_detail.dart';
import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Expenses backend is live; the app talks to the real repository.
final Provider<ExpenseRepository> expenseRepositoryProvider =
    Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(dioProvider));
});

/// Active date filter for the "All expenses" list (single day or range),
/// driven by the search field's date picker.
final expenseFilterProvider =
    NotifierProvider<ExpenseFilterNotifier, ExpenseFilter>(
  ExpenseFilterNotifier.new,
);

class ExpenseFilterNotifier extends Notifier<ExpenseFilter> {
  @override
  ExpenseFilter build() => const ExpenseFilter();

  void setSingle(DateTime date) => state = ExpenseFilter(date: date);

  void setRange(DateTime from, DateTime to) =>
      state = ExpenseFilter(from: from, to: to);

  void clear() => state = const ExpenseFilter();
}

/// Grouped expense cards for the active [expenseFilterProvider].
// ignore: specify_nonobvious_property_types
final expenseGroupsProvider =
    FutureProvider.autoDispose<List<ExpenseGroup>>((ref) {
  final filter = ref.watch(expenseFilterProvider);
  return ref.watch(expenseRepositoryProvider).groupedByDate(filter);
});

/// Full detail for one date, keyed by `yyyy-MM-dd`.
// ignore: specify_nonobvious_property_types
final expenseDetailProvider =
    FutureProvider.autoDispose.family<ExpenseDetail, String>((ref, dateKey) {
  return ref
      .watch(expenseRepositoryProvider)
      .detailByDate(DateTime.parse(dateKey));
});
