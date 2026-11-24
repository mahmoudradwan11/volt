import 'package:flutter/material.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/core/themes/app_colors.dart';

/// The "Payment" tab body. There is no payment-method API on the backend,
/// so this is presentational: a card preview plus a locally-selected
/// payment method.
class PaymentBody extends StatefulWidget {
  const PaymentBody({super.key});

  @override
  State<PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  String selectedMethod = 'Visa';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'Your Card',
          style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Container(
          height: 160,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.p3Color, AppColors.defaultColor],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visa Gold',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.wifi_rounded, color: Colors.white70, size: 18),
                ],
              ),
              Icon(Icons.sim_card_rounded,
                  color: Colors.white70, size: 26),
              Text(
                '****  ****  ****  9010',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white54, fontSize: 9),
                  ),
                  Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Other payment method',
          style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
        ),
        const SizedBox(height: 8),
        _MethodRow(
          icon: Icons.credit_card_rounded,
          name: 'Master Card',
          selected: selectedMethod == 'Master Card',
          onTap: () => setState(() => selectedMethod = 'Master Card'),
        ),
        _MethodRow(
          icon: Icons.account_balance_wallet_outlined,
          name: 'Paypal',
          selected: selectedMethod == 'Paypal',
          onTap: () => setState(() => selectedMethod = 'Paypal'),
        ),
        _MethodRow(
          icon: Icons.credit_card_rounded,
          name: 'Visa',
          selected: selectedMethod == 'Visa',
          onTap: () => setState(() => selectedMethod = 'Visa'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () =>
              showToast('Adding cards is not available yet', ToastStates.WARNING),
          icon: Icon(Icons.add_card_rounded,
              color: AppColors.subTextColor, size: 18),
          label: Text(
            'Add New Payment Method',
            style: TextStyle(color: AppColors.subTextColor, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _MethodRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _MethodRow({
    required this.icon,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.defaultColor : AppColors.p2Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.p3Color : AppColors.borderColor,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.subTextColor, size: 20),
        title: Text(
          name,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          selected
              ? Icons.radio_button_checked_rounded
              : Icons.radio_button_off_rounded,
          color: selected ? AppColors.p3Color : AppColors.subTextColor,
          size: 20,
        ),
      ),
    );
  }
}
