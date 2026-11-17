import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:volt/features/Auth/controllers/login_cubit/login_cubit.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/models/review_model.dart';

Widget buildReviewItem(ReviewsItems reviewModel, context, id) => Container(
  margin: const EdgeInsets.symmetric(vertical: 6),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: const Color(0xFF071020),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFF172541)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // =========================
      // User + Date
      // =========================
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(reviewModel.user!.profileImage!),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reviewModel.user!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      DateFormat(
                        'dd-MM-yyyy',
                      ).format(DateTime.tryParse(reviewModel.createdAt!)!),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                // =========================
                // Rating
                // =========================
                _buildRating(reviewModel.rating.toDouble()),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      // =========================
      // Comment
      // =========================
      Text(
        reviewModel.comment!,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
          height: 1.5,
        ),
      ),

      // =========================
      // Delete
      // =========================
      if (reviewModel.user!.name ==
          LoginCubit.get(context).loginModel!.user!.name)
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: IconButton(
            onPressed: () {
              ProductCubit.get(context).deleteReview(reviewModel.sId, id);
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white54,
              size: 20,
            ),
          ),
        ),
    ],
  ),
);

// =========================
// Rating
// =========================

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
