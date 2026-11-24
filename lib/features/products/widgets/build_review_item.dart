import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:volt/features/Auth/controllers/login_cubit/login_cubit.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/models/review_model.dart';
import 'package:volt/core/themes/app_colors.dart';

Widget buildReviewItem(ReviewsItems reviewModel, context, id) {
  // LoginCubit is only provided on the login route, so reading it from
  // anywhere else throws ProviderNotFoundException. Guard the lookup and
  // fall back to hiding the delete button when it is not available.
  String? currentUserName;
  try {
    currentUserName = LoginCubit.get(context).loginModel?.user?.name;
  } catch (_) {}
  final bool isMine =
      currentUserName != null && reviewModel.user?.name == currentUserName;

  return Container(
  margin: const EdgeInsets.symmetric(vertical: 6),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.p2Color,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderColor),
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
                        style: TextStyle(
                          color: AppColors.textColor,
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
                      style: TextStyle(
                        color: AppColors.subTextColor,
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
        style: TextStyle(
          color: AppColors.subTextColor,
          fontSize: 12,
          height: 1.5,
        ),
      ),

      // =========================
      // Delete
      // =========================
      if (isMine)
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: IconButton(
            onPressed: () {
              ProductCubit.get(context).deleteReview(reviewModel.sId, id);
            },
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.subTextColor,
              size: 20,
            ),
          ),
        ),
    ],
  ),
  );
}

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
