import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Receipt upload area: a dashed-border prompt when empty, or a thumbnail with
/// a remove button once a file is chosen.
class ReceiptUploader extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const ReceiptUploader({
    super.key,
    required this.file,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file!,
              key: const Key('receipt-thumbnail'),
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: AppColors.surfaceSecondary,
                child: const Icon(Icons.receipt_long, size: 40),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              key: const Key('receipt-remove'),
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      key: const Key('receipt-upload-area'),
      onTap: onTap,
      child: Container(
        height: 96,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textTertiary,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined,
                color: AppColors.textSecondary),
            const SizedBox(height: 6),
            Text('Attach a receipt', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
