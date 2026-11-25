import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/products/models/product_model.dart';

String formatPrice(dynamic v) {
  if (v == null) return '-';
  final n = v is num ? v : num.tryParse(v.toString());
  if (n == null) return v.toString();
  return n == n.roundToDouble() ? n.toInt().toString() : n.toString();
}

/// One product row in the admin lists: image, name, details, price (with
/// the offer if any), sales and edit / delete buttons.
class AdminProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const AdminProductTile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(6),
            child: CachedNetworkImage(
              imageUrl: product.image ?? '',
              fit: BoxFit.contain,
              placeholder: (c, u) => const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (c, u, e) => Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.subTextColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (product.name ?? '').trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${(product.company ?? '').trim()} · ${product.status ?? ''}'
                  ' · Stock ${product.countInStock ?? 0}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      formatPrice(product.price),
                      style: TextStyle(
                        color: AppColors.limeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (product.hasOffer) ...[
                      const SizedBox(width: 6),
                      Text(
                        formatPrice(product.originalPrice),
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.p3Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${formatPrice(product.discountPercent)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      '${product.sales} sold',
                      style: TextStyle(
                        color: AppColors.subTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.p3Color,
                    size: 20,
                  ),
                ),
              ),
              InkWell(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
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
}

/// Confirms a delete, then runs [onConfirm]. Same dialog look as sign out.
void confirmDeleteProduct(
  BuildContext context,
  Product product,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.p2Color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(
        'Delete "${(product.name ?? '').trim()}"? Users will no longer see it.',
        style: TextStyle(color: AppColors.textColor, fontSize: 14),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(90, 40),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Cancel', style: TextStyle(color: AppColors.textColor)),
        ),
      ],
    ),
  );
}
