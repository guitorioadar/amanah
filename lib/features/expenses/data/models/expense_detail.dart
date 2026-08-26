import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:intl/intl.dart';

/// One expense line inside a date group — a single category + its amounts. The
/// detail table renders [category] on the left and `before + tax` on the right.
class ExpenseLineItem {
  const ExpenseLineItem({
    required this.id,
    required this.category,
    required this.amountBeforeTax,
    required this.amountAfterTax,
    required this.hasReceipt,
    this.description,
  });

  factory ExpenseLineItem.fromJson(Map<String, dynamic> json) =>
      ExpenseLineItem(
        id: json['id'] as int,
        category: json['category'] as String? ?? '',
        amountBeforeTax: parseAmount(json['amount_before_tax']),
        amountAfterTax: parseAmount(json['amount_after_tax']),
        hasReceipt: json['has_receipt'] as bool? ?? false,
        description: json['description'] as String?,
      );

  final int id;
  final String category;
  final num amountBeforeTax;
  final num amountAfterTax;
  final bool hasReceipt;
  final String? description;

  /// Tax portion = after − before (never negative).
  num get tax {
    final delta = amountAfterTax - amountBeforeTax;
    return delta > 0 ? delta : 0;
  }
}

/// An uploaded receipt file attached to an expense in the group. [isImage]
/// splits the thumbnail grid from the file rows on the detail screen.
class ExpenseReceipt {
  const ExpenseReceipt({
    required this.id,
    required this.originalName,
    required this.url,
    required this.isImage,
    this.expenseId,
    this.extension,
    this.mimeType,
    this.humanSize,
  });

  factory ExpenseReceipt.fromJson(Map<String, dynamic> json) => ExpenseReceipt(
        id: json['id'] as int,
        originalName: json['original_name'] as String? ?? 'Receipt',
        url: json['url'] as String? ?? '',
        isImage: json['is_image'] as bool? ?? false,
        expenseId: json['expense_id'] as int?,
        extension: json['extension'] as String?,
        mimeType: json['mime_type'] as String?,
        humanSize: json['human_size'] as String?,
      );

  final int id;
  final String originalName;
  final String url;
  final bool isImage;
  final int? expenseId;
  final String? extension;
  final String? mimeType;
  final String? humanSize;
}

/// Full detail for one date — `GET /expenses/by-date/{date}`. Aggregates the
/// same summary fields as [ExpenseGroup] plus the per-expense [lineItems] and
/// the pooled [receipts].
class ExpenseDetail {
  const ExpenseDetail({
    required this.expenseDate,
    required this.categories,
    required this.clients,
    required this.expensesCount,
    required this.totalBeforeTax,
    required this.totalAfterTax,
    required this.receiptsCount,
    required this.receiptsRequired,
    required this.lineItems,
    required this.receipts,
  });

  factory ExpenseDetail.fromJson(Map<String, dynamic> json) => ExpenseDetail(
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
        lineItems: (json['line_items'] as List? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ExpenseLineItem.fromJson)
            .toList(),
        receipts: (json['receipts'] as List? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ExpenseReceipt.fromJson)
            .toList(),
      );

  final DateTime expenseDate;
  final List<String> categories;
  final List<ExpenseClientBrief> clients;
  final int expensesCount;
  final num totalBeforeTax;
  final num totalAfterTax;
  final int receiptsCount;
  final int receiptsRequired;
  final List<ExpenseLineItem> lineItems;
  final List<ExpenseReceipt> receipts;

  /// Number of expenses in the group that have at least one receipt. The
  /// detail endpoint's own `receipts_count` is unreliable (comes back 0), so
  /// derive it from the line items' `has_receipt` flag, falling back to the
  /// distinct expenses represented in the pooled receipts.
  int get receiptsHave {
    final byFlag = lineItems.where((l) => l.hasReceipt).length;
    final byFiles =
        receipts.map((r) => r.expenseId).whereType<int>().toSet().length;
    return byFlag >= byFiles ? byFlag : byFiles;
  }

  /// Receipts expected = one per expense in the group.
  int get receiptsNeed =>
      expensesCount > 0 ? expensesCount : receiptsRequired;

  ReceiptState get receiptState =>
      receiptStateOf(receiptsHave, receiptsNeed);

  List<ExpenseReceipt> get imageReceipts =>
      receipts.where((r) => r.isImage).toList();

  List<ExpenseReceipt> get fileReceipts =>
      receipts.where((r) => !r.isImage).toList();

  String get dateKey => DateFormat('yyyy-MM-dd').format(expenseDate);
}
