import 'package:intl/intl.dart';

/// Receipt-coverage state for a date group. Drives the tri-color receipt
/// pill on the card / detail summary (red none, amber partial, green full).
enum ReceiptState { none, partial, complete }

/// `receipts_count` vs `receipts_required` → coverage state. A group with no
/// required receipts is treated as complete once it has at least one (and
/// [ReceiptState.none] when it has zero) so the pill never divides by zero.
ReceiptState receiptStateOf(int count, int required) {
  if (count <= 0) return ReceiptState.none;
  if (required <= 0 || count >= required) return ReceiptState.complete;
  return ReceiptState.partial;
}

/// `$1,910.00` — the app-wide money format for expense amounts.
String formatMoney(num value) =>
    NumberFormat.currency(symbol: r'$', decimalDigits: 2).format(value);

/// Parses a JSON number that the API sends either as a number (`1608`) or a
/// decimal string (`"566.00"`).
num parseAmount(Object? raw) {
  if (raw is num) return raw;
  if (raw is String) return num.tryParse(raw) ?? 0;
  return 0;
}

/// A client as it appears inside a grouped-expense payload — just enough to
/// render an avatar/name. Richer fields (email) only exist on the detail.
class ExpenseClientBrief {
  const ExpenseClientBrief({
    required this.id,
    required this.name,
    this.businessName,
    this.businessLogoUrl,
    this.profilePictureUrl,
    this.email,
  });

  factory ExpenseClientBrief.fromJson(Map<String, dynamic> json) =>
      ExpenseClientBrief(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        businessName: json['business_name'] as String?,
        businessLogoUrl: json['business_logo_url'] as String?,
        profilePictureUrl: json['profile_picture_url'] as String?,
        email: json['email'] as String?,
      );

  final int id;
  final String name;
  final String? businessName;
  final String? businessLogoUrl;
  final String? profilePictureUrl;
  final String? email;
}

/// One card on the "All expenses" list — every expense the auditor logged on a
/// single [expenseDate], aggregated by `GET /expenses/by-date`. Chips render
/// [categories]; the footer shows [totalAfterTax] + the receipt pill.
class ExpenseGroup {
  const ExpenseGroup({
    required this.expenseDate,
    required this.categories,
    required this.clients,
    required this.expensesCount,
    required this.totalBeforeTax,
    required this.totalAfterTax,
    required this.receiptsCount,
    required this.receiptsRequired,
  });

  factory ExpenseGroup.fromJson(Map<String, dynamic> json) => ExpenseGroup(
        expenseDate: DateTime.parse(json['expense_date'] as String),
        categories:
            (json['categories'] as List? ?? const []).cast<String>(),
        clients: (json['clients'] as List? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ExpenseClientBrief.fromJson)
            .toList(),
        expensesCount: json['expenses_count'] as int? ?? 0,
        totalBeforeTax: parseAmount(json['total_before_tax']),
        totalAfterTax: parseAmount(json['total_after_tax']),
        receiptsCount: json['receipts_count'] as int? ?? 0,
        receiptsRequired: json['receipts_required'] as int? ?? 0,
      );

  final DateTime expenseDate;
  final List<String> categories;
  final List<ExpenseClientBrief> clients;
  final int expensesCount;
  final num totalBeforeTax;
  final num totalAfterTax;
  final int receiptsCount;
  final int receiptsRequired;

  ReceiptState get receiptState =>
      receiptStateOf(receiptsCount, receiptsRequired);

  /// `yyyy-MM-dd` — the path segment for `GET /expenses/by-date/{date}`.
  String get dateKey => DateFormat('yyyy-MM-dd').format(expenseDate);
}
