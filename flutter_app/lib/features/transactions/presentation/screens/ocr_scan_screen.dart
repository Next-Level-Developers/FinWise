import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transactions_provider.dart';

class OcrScanScreen extends ConsumerStatefulWidget {
  const OcrScanScreen({super.key});

  @override
  ConsumerState<OcrScanScreen> createState() => _OcrScanScreenState();
}

class _OcrScanScreenState extends ConsumerState<OcrScanScreen> {
  bool _saving = false;

  Future<void> _saveExtractedTransaction() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final TransactionEntity tx = TransactionEntity(
        id: '',
        title: 'Cafe Bistro',
        amount: 280,
        datetime: DateTime.now(),
        isDebit: true,
        category: 'food',
        source: 'ocr_scan',
        paymentMethod: 'upi',
      );
      await ref.read(addTransactionUseCaseProvider).call(tx);
      if (!mounted) {
        return;
      }
      context.pop(true);
    } catch (error) {
      final String message =
          error.toString().contains('Setting up transactions data')
          ? 'Setting up transactions data… please wait'
          : 'Unable to save transaction right now.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF111111), Color(0xFF0A0A0A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.document_scanner,
                  size: 72,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16),
                Text(
                  'Point camera at your receipt',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The scan zone will auto-capture totals and merchant data.',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            left: AppDimensions.paddingL,
            right: AppDimensions.paddingL,
            bottom: AppDimensions.paddingXL,
            child: Column(
              children: <Widget>[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textPrimary, width: 3),
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Extracted Info',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Amount: ₹280 • Merchant: Cafe Bistro • Category: Food',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _saveExtractedTransaction,
                    child: Text(_saving ? 'Saving...' : 'Confirm & Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
