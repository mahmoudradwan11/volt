import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/category/controllers/category_cubit.dart';
import 'package:volt/features/category/controllers/category_states.dart';
import 'package:volt/features/category/screens/category_products_screen.dart';
import 'package:volt/features/products/data/product_cate_list.dart';
import 'package:volt/features/products/models/user_home_cate_model.dart';
import 'package:volt/features/products/widgets/build_product_item.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  /// The shared app-level CategoryCubit (registered in main.dart), or
  /// null when this screen is opened in a tree that doesn't have it.
  static CategoryCubit? _rootCubit(BuildContext context) {
    try {
      return context.read<CategoryCubit>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normal case: main.dart's MultiBlocProvider supplies the cubit.
    if (_rootCubit(context) != null) {
      return const _CategoryView();
    }
    // Fallback for a tree missing the root provider (for example a
    // project the feature was merged into without the main.dart change):
    // provide a local instance so the screen still opens.
    return BlocProvider(
      create: (_) => CategoryCubit(),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatefulWidget {
  const _CategoryView();

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<_CategoryView> {
  final searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search bar - same UI as the home screen's search.
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
                  onChanged: (value) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 400), () {
                      if (mounted) {
                        context.read<CategoryCubit>().search(value);
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryStates>(
                builder: (context, state) {
                  final cubit = CategoryCubit.get(context);

                  if (state is CategoryLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CategoryErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: AppColors.subTextColor, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Something went wrong loading categories',
                            style: TextStyle(
                                color: AppColors.subTextColor, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          MaterialButton(
                            color: AppColors.defaultColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () => cubit.getCategories(),
                            child: Text(
                              'Retry',
                              style: TextStyle(color: AppColors.textColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Search results replace the grid while searching.
                  final results = cubit.searchResults;
                  if (results != null) {
                    if (cubit.searching) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (results.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found',
                          style:
                              TextStyle(color: AppColors.subTextColor, fontSize: 14),
                        ),
                      );
                    }
                    return GridView.builder(
                      itemCount: results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 160 / 200,
                      ),
                      itemBuilder: (context, index) =>
                          BuildProductItem(productModel: results[index]),
                    );
                  }

                  // Categories grid with product counts.
                  return GridView.builder(
                    itemCount: userHomeCateModel.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => _buildCategoryCard(
                      userHomeCateModel[index],
                      cubit,
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

  Widget _buildCategoryCard(UserHomeCateModel cate, CategoryCubit cubit) {
    final count = cubit.categoryCount(cate.apiCategory);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(
              cateModel: cate,
              products: cubit.productsByCategory[cate.apiCategory] ?? [],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.p2Color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              cate.image,
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              cate.title,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count Products',
              style: TextStyle(
                color: AppColors.subTextColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
