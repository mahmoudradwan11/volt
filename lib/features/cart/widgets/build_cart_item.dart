import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/features/cart/controllers/cart_cubit.dart';
import 'package:volt/features/cart/models/cart_model.dart';
import 'package:volt/core/themes/app_colors.dart';

/// One cart line: product image, name, company, unit price, a quantity
/// stepper and a delete button.
class BuildCartItem extends StatelessWidget {
  const BuildCartItem({super.key, required this.product});

  final CartProduct product;

  @override
  Widget build(BuildContext context) {
    final cubit = CartCubit.get(context);
    final price = (product.price as num?)?.toDouble() ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: product.image ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 70,
                height: 70,
                color: AppColors.p2Color,
              ),
              errorWidget: (context, url, error) => Container(
                width: 70,
                height: 70,
                color: AppColors.p2Color,
                child:  Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.borderColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name, company, price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.company ?? '',
                  style: TextStyle(
                    color: AppColors.subTextColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Quantity stepper + delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _stepperButton(
                    icon: Icons.remove,
                    onTap: () => cubit.decreaseQuantity(product),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // While this item updates on the server, show a small
                    // spinner in place of the quantity; the row and the
                    // rest of the screen stay visible.
                    child: cubit.updatingProductId == product.sId
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.subTextColor,
                            ),
                          )
                        : Text(
                            '${product.quantity ?? 0}',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  _stepperButton(
                    icon: Icons.add,
                    onTap: () => cubit.updateQuantity(
                      product.sId!,
                      (product.quantity ?? 0) + 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => cubit.removeFromCart(product.sId),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.subTextColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.p2Color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, color: AppColors.textColor, size: 16),
      ),
    );
  }
}
