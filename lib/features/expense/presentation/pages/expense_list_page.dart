import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/category_icon.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/entities/expense_entity.dart';
import '../providers/expense_provider.dart';
import 'add_expense_page.dart';

class ExpenseListPage extends ConsumerStatefulWidget {
  const ExpenseListPage({super.key});

  @override
  ConsumerState<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends ConsumerState<ExpenseListPage> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final _searchCtrl = TextEditingController();
  final _debouncer = Debouncer(duration: const Duration(milliseconds: 350));
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(expenseFilterControllerProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search expenses…',
                  border: InputBorder.none,
                ),
                onChanged: (q) => _debouncer.run(() {
                  setState(() => _searchQuery = q.trim().toLowerCase());
                }),
              )
            : const Text('Expenses'),
        leading: IconButton(
          icon: Icon(_showSearch ? Icons.close : Icons.arrow_back),
          onPressed: () {
            if (_showSearch) {
              _searchCtrl.clear();
              setState(() {
                _showSearch = false;
                _searchQuery = '';
              });
            } else {
              context.canPop() ? context.pop() : context.go(RouteNames.home);
            }
          },
        ),
        actions: [
          IconButton(
            key: const Key('search-expenses-button'),
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            tooltip: 'Search',
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              if (!_showSearch)
                _MonthFilter(
                  selectedMonth: filter.month,
                  months: _months,
                  onSelected: (m) =>
                      ref.read(expenseFilterControllerProvider.notifier).setMonth(m),
                ),
              Expanded(
                child: expensesAsync.when(
                  loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => ErrorState(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(expensesStreamProvider),
                  ),
                  data: (expenses) {
                    // Apply search filter client-side.
                    final filtered = _searchQuery.isEmpty
                        ? expenses
                        : expenses.where((e) {
                            return e.description
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                e.category
                                    .toLowerCase()
                                    .contains(_searchQuery);
                          }).toList();

                    if (filtered.isEmpty) {
                      return EmptyState(
                        title: _searchQuery.isEmpty
                            ? 'No expenses'
                            : 'No results',
                        message: _searchQuery.isEmpty
                            ? 'No expenses for this month yet.'
                            : 'No expenses match "$_searchQuery".',
                        icon: Icons.receipt_long_outlined,
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async =>
                          ref.invalidate(expensesStreamProvider),
                      child: _GroupedList(expenses: filtered),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthFilter extends StatelessWidget {
  final int selectedMonth;
  final List<String> months;
  final ValueChanged<int> onSelected;

  const _MonthFilter({
    required this.selectedMonth,
    required this.months,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final month = i + 1;
          final selected = month == selectedMonth;
          return GestureDetector(
            key: Key('month-chip-$month'),
            onTap: () => onSelected(month),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                months[i],
                style: AppTextStyles.titleMedium.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GroupedList extends ConsumerWidget {
  final List<ExpenseEntity> expenses;

  const _GroupedList({required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group by calendar day, preserving the date-DESC order from the stream.
    final groups = <String, List<ExpenseEntity>>{};
    for (final e in expenses) {
      final key = formatDateShort(e.date);
      groups.putIfAbsent(key, () => []).add(e);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(entry.key,
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textTertiary)),
          ),
          for (final expense in entry.value)
            _ExpenseTile(expense: expense),
        ],
      ],
    );
  }
}

class _ExpenseTile extends ConsumerWidget {
  final ExpenseEntity expense;

  const _ExpenseTile({required this.expense});

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('Remove "${expense.description}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountColor =
        expense.isIncome ? AppColors.income : AppColors.expense;
    final sign = expense.isIncome ? '+' : '-';

    return Dismissible(
      key: Key('expense-${expense.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) async {
        final messenger = ScaffoldMessenger.of(context);
        final ok = await ref
            .read(expenseControllerProvider.notifier)
            .deleteExpense(expense);
        messenger.showSnackBar(
          SnackBar(content: Text(ok ? 'Expense deleted' : 'Delete failed')),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddExpensePage(existing: expense),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Row(
              children: [
                CategoryIcon(category: expense.category),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description.isEmpty
                            ? expense.category
                            : expense.description,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(expense.category, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$sign${formatCurrency(expense.amount)}',
                      style:
                          AppTextStyles.titleLarge.copyWith(color: amountColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo(expense.date),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
