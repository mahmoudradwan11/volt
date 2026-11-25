import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/admin/controllers/admin_products_cubit.dart';
import 'package:volt/features/admin/controllers/admin_products_states.dart';
import 'package:volt/features/admin/screens/admin_product_form_screen.dart';
import 'package:volt/features/admin/widgets/admin_product_tile.dart';
import 'package:volt/features/products/models/product_model.dart';

/// Admin "Products" tab: every product with search and a category filter,
/// plus add / edit / delete. Reused by the company screen with [company].
class AdminProductsScreen extends StatefulWidget {
  /// When set, only this company's products show, and "add" pre-fills it.
  final String? company;
  const AdminProductsScreen({super.key, this.company});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final searchController = TextEditingController();
  String query = '';
  String? category;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminProductsCubit>();
    if (cubit.products.isEmpty) cubit.loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> _filtered(AdminProductsCubit cubit) {
    return cubit.products.where((p) {
      if (widget.company != null &&
          (p.company ?? '').trim().toLowerCase() !=
              widget.company!.trim().toLowerCase()) {
        return false;
      }
      if (category != null && p.category != category) return false;
      if (query.isNotEmpty &&
          !(p.name ?? '').toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openForm({Product? product}) {
    final cubit = context.read<AdminProductsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AdminProductFormScreen(
            product: product,
            presetCompany: widget.company,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompany = widget.company != null;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: Text(isCompany ? widget.company! : 'Products'),
        centerTitle: true,
        automaticallyImplyLeading: isCompany,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.p3Color,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.p2Color,
                border: Border.all(
                  color: AppColors.p3Color.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              height: 55,
              child: Center(
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: AppColors.subTextColor),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: AppColors.textColor,
                    ),
                  ),
                  onChanged: (v) => setState(() => query = v.trim()),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('All', category == null, () {
                    setState(() => category = null);
                  }),
                  for (final c in AdminProductsCubit.categories)
                    _chip(c, category == c, () {
                      setState(() => category = category == c ? null : c);
                    }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<AdminProductsCubit, AdminProductsStates>(
                builder: (context, state) {
                  final cubit = AdminProductsCubit.get(context);
                  if (state is AdminProductsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdminProductsErrorState &&
                      cubit.products.isEmpty) {
                    return Center(
                      child: TextButton(
                        onPressed: () => cubit.loadProducts(),
                        child: const Text('Could not load. Tap to retry'),
                      ),
                    );
                  }
                  final items = _filtered(cubit);
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No products',
                        style: TextStyle(color: AppColors.subTextColor),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => cubit.loadProducts(silent: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: items.length,
                      itemBuilder: (context, i) => AdminProductTile(
                        product: items[i],
                        onEdit: () => _openForm(product: items[i]),
                        onDelete: () => confirmDeleteProduct(
                          context,
                          items[i],
                          () => cubit.deleteProduct(items[i]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.p3Color : AppColors.p2Color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
