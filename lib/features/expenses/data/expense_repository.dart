import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/expenses/data/models/expense_detail.dart';
import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:amanah/features/expenses/data/models/expense_options.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

/// Filter for the grouped-expense list. [date] pins a single day; [from]/[to]
/// select a range. The search field in the design drives these via a date
/// picker (no free-text), but [keyword] is kept for completeness.
class ExpenseFilter {
  const ExpenseFilter({this.keyword, this.date, this.from, this.to});

  final String? keyword;
  final DateTime? date;
  final DateTime? from;
  final DateTime? to;

  bool get isEmpty =>
      (keyword == null || keyword!.trim().isEmpty) &&
      date == null &&
      from == null &&
      to == null;

  ExpenseFilter cleared() => const ExpenseFilter();
}

/// Reads/writes the signed-in auditor's own expenses, grouped by date.
abstract interface class ExpenseRepository {
  /// Grouped expense cards — `GET /expenses/by-date`.
  Future<List<ExpenseGroup>> groupedByDate(ExpenseFilter filter);

  /// Full detail for one date — `GET /expenses/by-date/{date}`.
  Future<ExpenseDetail> detailByDate(DateTime date);

  /// Create an expense — `POST /expenses` (multipart). At least one receipt is
  /// required by the backend (422 otherwise).
  Future<void> createExpense({
    required int categoryId,
    required List<int> clientIds,
    required num amountBeforeTax,
    required num amountAfterTax,
    required DateTime date,
    required List<String> receiptPaths,
    String? note,
  });

  /// Active clients for the picker — `GET /clients/dropdown`.
  Future<List<ClientOption>> clientOptions({String? keyword});

  /// Active categories for the picker — `GET /expense-categories/dropdown`.
  Future<List<ExpenseCategoryOption>> categoryOptions({String? keyword});
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._dio);

  final Dio _dio;

  static final _dateFmt = DateFormat('yyyy-MM-dd');

  @override
  Future<List<ExpenseGroup>> groupedByDate(ExpenseFilter filter) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/expenses/by-date',
        queryParameters: {
          if (filter.keyword != null && filter.keyword!.trim().isNotEmpty)
            'keyword': filter.keyword!.trim(),
          if (filter.date != null) 'date': _dateFmt.format(filter.date!),
          if (filter.from != null) 'date_from': _dateFmt.format(filter.from!),
          if (filter.to != null) 'date_to': _dateFmt.format(filter.to!),
          'per_page': 50,
        },
      );
      final data = (res.data!['data'] as List).cast<Map<String, dynamic>>();
      return data.map(ExpenseGroup.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<ExpenseDetail> detailByDate(DateTime date) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/expenses/by-date/${_dateFmt.format(date)}',
      );
      return ExpenseDetail.fromJson(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> createExpense({
    required int categoryId,
    required List<int> clientIds,
    required num amountBeforeTax,
    required num amountAfterTax,
    required DateTime date,
    required List<String> receiptPaths,
    String? note,
  }) async {
    try {
      final form = FormData();
      form.fields
        ..add(MapEntry('expense_category_id', '$categoryId'))
        ..add(MapEntry('client_ids', clientIds.join(',')))
        ..add(MapEntry('amount_before_tax', '$amountBeforeTax'))
        ..add(MapEntry('amount_after_tax', '$amountAfterTax'))
        ..add(MapEntry('expense_date', _dateFmt.format(date)));
      final trimmed = note?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        form.fields.add(MapEntry('note', trimmed));
      }
      for (final path in receiptPaths) {
        form.files.add(
          MapEntry('receipts[]', await MultipartFile.fromFile(path)),
        );
      }
      await _dio.post<Map<String, dynamic>>('/expenses', data: form);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<List<ClientOption>> clientOptions({String? keyword}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/clients/dropdown',
        queryParameters: {
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
        },
      );
      final data = (res.data!['data'] as List).cast<Map<String, dynamic>>();
      return data.map(ClientOption.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<List<ExpenseCategoryOption>> categoryOptions({String? keyword}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/expense-categories/dropdown',
        queryParameters: {
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
        },
      );
      final data = (res.data!['data'] as List).cast<Map<String, dynamic>>();
      return data.map(ExpenseCategoryOption.fromJson).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
