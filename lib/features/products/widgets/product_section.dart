import 'package:flutter/material.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/widgets/build_product_item.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<Product>? products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products == null || products!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products!.length,
            separatorBuilder: (_, index) =>
            const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return BuildProductItem(
                productModel: products![index],
              );
            },
          ),
        ),
      ],
    );
  }
}