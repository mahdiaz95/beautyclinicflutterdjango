// ui/pages/wallet_page.dart

import 'package:PARLACLINIC/features/home/view/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  IconData _iconForType(String type) {
    return type == 'deposit' ? Icons.arrow_downward : Icons.arrow_upward;
  }

  Color _colorForType(String type) {
    return type == 'deposit' ? Colors.green : Colors.red;
  }

  String _formatCurrency(String amount) {
    final formatter = NumberFormat.decimalPattern('fa');
    return formatter.format(int.tryParse(amount) ?? 0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('100 تراکنش اخیر'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            await ref.read(homeViewModelProvider.notifier).refresh(),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطا: $e')),
          data: (walletData) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Text('موجودی', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatCurrency(walletData.balance)} تومان',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('تراکنش‌های اخیر',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...walletData.transactions.map((tx) {
                return Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          _colorForType(tx.transactionType).withOpacity(0.1),
                      child: Icon(
                        _iconForType(tx.transactionType),
                        color: _colorForType(tx.transactionType),
                      ),
                    ),
                    title: Text(
                      '${tx.transactionTypeDisplay} - ${_formatCurrency(tx.amount)} تومان',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE d MMM yyyy, HH:mm', 'fa_IR')
                              .format(tx.createdAt),
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (tx.description != null &&
                            tx.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              tx.description!,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
