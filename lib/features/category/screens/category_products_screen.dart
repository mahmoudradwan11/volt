import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/models/user_home_cate_model.dart';
import 'package:volt/features/products/widgets/build_product_item.dart';

/// All products of one category (new and used combined), with a
/// New / Used filter. The products come from the categories screen,
/// which already loaded them from the API.
class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    required this.cateModel,
    required this.products,
  });

  final UserHomeCateModel cateModel;
  final List<Product> products;

  @override
  State<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  // 0 = All, 1 = New, 2 = Used
  int selectedFilter = 0;
  static const filterLabels = ['All', 'New', 'Used'];

  final searchController = TextEditingController();

  /// Current search text; filters this category's products locally by
  /// name, company or description, on top of the New / Used filter.
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    var products = widget.products;
    if (selectedFilter != 0) {
      final status = filterLabels[selectedFilter];
      products =
          products.where((product) => product.status == status).toList();
    }
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      products = products.where((product) {
        return (product.name ?? '').toLowerCase().contains(query) ||
            (product.company ?? '').toLowerCase().contains(query) ||
            (product.description ?? '').toLowerCase().contains(query);
      }).toList();
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: Text(widget.cateModel.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search within this category - same UI as the home search.
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
                  onChanged: (value) =>
                      setState(() => searchQuery = value),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // New / Used filter, same chip colors as the home categories.
            Row(
              children: List.generate(filterLabels.length, (index) {
                final selected = selectedFilter == index;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: InkWell(
                    onTap: () => setState(() => selectedFilter = index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? HexColor('#603FF8')
                            : AppColors.p2Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filterLabels[index],
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.textColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style:
                            TextStyle(color: AppColors.subTextColor, fontSize: 14),
                      ),
                    )
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 160 / 200,
                      ),
                      itemBuilder: (context, index) =>
                          BuildProductItem(productModel: products[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
