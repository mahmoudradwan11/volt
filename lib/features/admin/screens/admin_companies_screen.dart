import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/admin/controllers/admin_products_cubit.dart';
import 'package:volt/features/admin/controllers/admin_products_states.dart';
import 'package:volt/features/admin/screens/admin_products_screen.dart';

/// Admin "Companies" tab: the supplier companies with their product
/// counts. Opening one shows that company's products (add / edit / delete).
class AdminCompaniesScreen extends StatefulWidget {
  const AdminCompaniesScreen({super.key});

  @override
  State<AdminCompaniesScreen> createState() => _AdminCompaniesScreenState();
}

class _AdminCompaniesScreenState extends State<AdminCompaniesScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminProductsCubit>();
    if (cubit.products.isEmpty) cubit.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('Companies'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AdminProductsCubit, AdminProductsStates>(
        builder: (context, state) {
          final cubit = AdminProductsCubit.get(context);
          if (state is AdminProductsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          final companies = cubit.companies;
          if (companies.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: () => cubit.loadProducts(),
                child: const Text('No companies. Tap to reload'),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => cubit.loadProducts(silent: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: companies.length,
              itemBuilder: (context, i) {
                final c = companies[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: AdminProductsScreen(company: c.name),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.p2Color,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.p3Color,
                          child: Text(
                            c.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            c.name,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          '${c.productCount} products',
                          style: TextStyle(
                            color: AppColors.subTextColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.subTextColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
