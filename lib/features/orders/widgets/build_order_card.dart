import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:volt/features/orders/models/order_model.dart';
import 'package:volt/core/themes/app_colors.dart';

class BuildOrderCard extends StatelessWidget {
  const BuildOrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final orderDate = DateTime.tryParse(order.createdAt ?? '');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // Order id + date/time
          // =========================
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order ${order.sId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                orderDate == null
                    ? ''
                    : DateFormat('dd MMM yyyy, hh:mm a').format(orderDate),
                style: TextStyle(
                  color: AppColors.subTextColor,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.p2Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.ageCategoryLabel,
                  style: const TextStyle(
                    color: Color(0xFF8B8D9C),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // Ordered products
          // =========================
          ...(order.items ?? []).map((item) => _buildOrderItem(item)),

          Divider(color: AppColors.borderColor, height: 24),

          // =========================
          // Status + total paid
          // =========================
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.p2Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status ?? '',
                  style: const TextStyle(
                    color: Color(0xFFC8DE22),
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total paid',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    '\$${order.totalPaid}',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (order.paymentMethod != null)
                    Text(
                      order.paymentMethod!,
                      style:
                          TextStyle(color: AppColors.subTextColor, fontSize: 10),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 52,
              height: 52,
              color: AppColors.p2Color,
              child: CachedNetworkImage(
                imageUrl: item.image ?? '',
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>  Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.borderColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} x \$${item.price}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                // The customer's own rating on this product, if they made one
                item.myRating == null
                    ?  Text(
                        'Not rated yet',
                        style: TextStyle(color: AppColors.borderColor, fontSize: 11),
                      )
                    : _buildRating(item.myRating!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Same star style used in the reviews UI
  Widget _buildRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: HexColor('#8B55FF'),
          size: 17,
        );
      }),
    );
  }
}
