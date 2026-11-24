import 'package:flutter/material.dart';
import 'package:volt/core/themes/app_colors.dart';

/// Language & Country picker. Placeholder for now: the selections are
/// shown but not applied - localization is paused and will wire these up.
class LanguageCountryScreen extends StatelessWidget {
  const LanguageCountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language & Country',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Select Your Country',
              style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const _SelectionPill(label: 'United States'),
            const SizedBox(height: 24),
            Text(
              'Select Your Language',
              style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const _SelectionPill(label: 'English'),
          ],
        ),
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  final String label;

  const _SelectionPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.check_circle_rounded, color: AppColors.p3Color, size: 20),
        ],
      ),
    );
  }
}
