import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/app_search_field.dart';
import 'package:amanah/features/expenses/data/models/expense_options.dart';
import 'package:amanah/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Multi-select client picker. Returns the chosen clients, or null if
/// dismissed without confirming.
Future<List<ClientOption>?> showSelectClientsSheet(
  BuildContext context, {
  required List<ClientOption> initial,
}) {
  return showModalBottomSheet<List<ClientOption>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _SelectClientsSheet(initial: initial),
  );
}

/// Single-select category picker. Returns the chosen category, or null if
/// dismissed without confirming.
Future<ExpenseCategoryOption?> showSelectCategorySheet(
  BuildContext context, {
  ExpenseCategoryOption? initial,
}) {
  return showModalBottomSheet<ExpenseCategoryOption>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _SelectCategorySheet(initial: initial),
  );
}

// ── Shared chrome ────────────────────────────────────────────────────────────

/// Centered title + close button + hairline, matching the modal design header.
class _SheetTopBar extends StatelessWidget {
  const _SheetTopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s4,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          const SizedBox(width: 44),
          Expanded(
            child: Center(
              child: Text(
                title,
                style:
                    AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/X.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconSubtle,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Square multi-select box.
class _CheckSquare extends StatelessWidget {
  const _CheckSquare({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? AppColors.brand : AppColors.bgDefault,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: selected ? AppColors.brand : AppColors.borderBold,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 16, color: AppColors.brandOnPrimary)
          : null,
    );
  }
}

/// Round single-select dot.
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.brand : AppColors.borderBold,
          width: selected ? 6 : 1.5,
        ),
      ),
    );
  }
}

// ── Clients ──────────────────────────────────────────────────────────────────

class _SelectClientsSheet extends ConsumerStatefulWidget {
  const _SelectClientsSheet({required this.initial});
  final List<ClientOption> initial;

  @override
  ConsumerState<_SelectClientsSheet> createState() =>
      _SelectClientsSheetState();
}

class _SelectClientsSheetState extends ConsumerState<_SelectClientsSheet> {
  final _search = TextEditingController();
  Timer? _debounce;

  List<ClientOption> _options = const [];
  late final Map<int, ClientOption> _selected = {
    for (final c in widget.initial) c.id: c,
  };
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({String? keyword}) async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final list = await ref
          .read(expenseRepositoryProvider)
          .clientOptions(keyword: keyword);
      if (!mounted) return;
      setState(() {
        // Only clients that have a business name are selectable, and the
        // business name is what we show.
        _options = list
            .where((c) => (c.businessName ?? '').trim().isNotEmpty)
            .toList();
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _load(keyword: value),
    );
  }

  void _toggle(ClientOption c) {
    setState(() {
      if (_selected.containsKey(c.id)) {
        _selected.remove(c.id);
      } else {
        _selected[c.id] = c;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PickerScaffold(
      title: 'Select clients',
      hintText: 'Search clients',
      search: _search,
      onSearch: _onSearch,
      loading: _loading,
      error: _error,
      onRetry: _load,
      confirmEnabled: _selected.isNotEmpty,
      onConfirm: () =>
          Navigator.of(context).pop(_selected.values.toList()),
      itemCount: _options.length,
      itemBuilder: (context, i) {
        final c = _options[i];
        final selected = _selected.containsKey(c.id);
        return _OptionRow(
          leading: _CheckSquare(selected: selected),
          title: c.businessName,
          subtitle: c.name,
          onTap: () => _toggle(c),
        );
      },
    );
  }
}

// ── Categories ───────────────────────────────────────────────────────────────

class _SelectCategorySheet extends ConsumerStatefulWidget {
  const _SelectCategorySheet({this.initial});
  final ExpenseCategoryOption? initial;

  @override
  ConsumerState<_SelectCategorySheet> createState() =>
      _SelectCategorySheetState();
}

class _SelectCategorySheetState extends ConsumerState<_SelectCategorySheet> {
  final _search = TextEditingController();
  Timer? _debounce;

  List<ExpenseCategoryOption> _options = const [];
  late int? _selectedId = widget.initial?.id;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({String? keyword}) async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final list = await ref
          .read(expenseRepositoryProvider)
          .categoryOptions(keyword: keyword);
      if (!mounted) return;
      setState(() {
        _options = list;
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _load(keyword: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PickerScaffold(
      title: 'Select categories',
      hintText: 'Search categories',
      search: _search,
      onSearch: _onSearch,
      loading: _loading,
      error: _error,
      onRetry: _load,
      confirmEnabled: _selectedId != null,
      onConfirm: () {
        final chosen = _options.firstWhere(
          (o) => o.id == _selectedId,
          orElse: () => widget.initial!,
        );
        Navigator.of(context).pop(chosen);
      },
      itemCount: _options.length,
      itemBuilder: (context, i) {
        final o = _options[i];
        return _OptionRow(
          leading: _RadioDot(selected: _selectedId == o.id),
          title: o.title,
          onTap: () => setState(() => _selectedId = o.id),
        );
      },
    );
  }
}

// ── Scaffold + row ───────────────────────────────────────────────────────────

class _PickerScaffold extends StatelessWidget {
  const _PickerScaffold({
    required this.title,
    required this.hintText,
    required this.search,
    required this.onSearch,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.confirmEnabled,
    required this.onConfirm,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String title;
  final String hintText;
  final TextEditingController search;
  final ValueChanged<String> onSearch;
  final bool loading;
  final bool error;
  final VoidCallback onRetry;
  final bool confirmEnabled;
  final VoidCallback onConfirm;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.sizeOf(context).height * 0.9;

    Widget body;
    if (loading) {
      body = const _PickerSkeleton();
    } else if (error) {
      body = _CenterMessage(
        message: "Couldn't load. Tap to retry.",
        onTap: onRetry,
      );
    } else if (itemCount == 0) {
      body = const _CenterMessage(message: 'No results.');
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetTopBar(title: title),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s4,
                AppSpacing.s2,
              ),
              child: AppSearchField(
                controller: search,
                onChanged: onSearch,
                hintText: hintText,
              ),
            ),
            Expanded(child: body),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s3,
                AppSpacing.s4,
                AppSpacing.s4 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: AppButton(
                label: 'Confirm',
                height: 48,
                onPressed: confirmEnabled ? onConfirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.leading,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyLRegular
                        .copyWith(color: AppColors.textDefault),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer list shown while options load.
class _PickerSkeleton extends StatelessWidget {
  const _PickerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s3,
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.skeletonBase,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Container(
                width: 180,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.skeletonBase,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.message, this.onTap});
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          message,
          style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
        ),
      ),
    );
  }
}
