
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/models/review_model.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/controllers/product_states.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final PageController _pageController = PageController();

  int currentImage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ProductCubit.get(context).getAllReviews(widget.product.sId);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final List<String> images =
    product.images != null && product.images!.isNotEmpty
        ? product.images!
        : [product.image ?? ''];

    final bool isUsed = product.status?.toLowerCase() == 'used';

    return Scaffold(
      backgroundColor: HexColor('#0E172E').withValues(alpha: 0.8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  _circleButton(
                    icon: product.inFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    iconColor: product.inFavorite == true
                        ? Colors.redAccent
                        : Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _circleButton(
                    icon: Icons.share_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Images
                    Container(
                      height: 310,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0B1530),
                            Color(0xFF050A18),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF1B2B50),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 30,
                            right: 30,
                            bottom: 30,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7040FF)
                                        .withValues(alpha: 0.25),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentImage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(25),
                                child: CachedNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF7040FF),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.white54,
                                        size: 55,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isUsed
                                    ? const Color(0xFF30374D)
                                    : const Color(0xFF7040FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                product.status?.toUpperCase() ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 18,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                    (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    height: 6,
                                    width: currentImage == index ? 18 : 6,
                                    decoration: BoxDecoration(
                                      color: currentImage == index
                                          ? const Color(0xFF8B55FF)
                                          : Colors.white30,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Image Thumbnails
                    if (images.length > 1)
                      Center(
                        child: SizedBox(
                          height: 65,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, index) =>
                            const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final bool selected = currentImage == index;

                              return GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0B1530),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFF7040FF)
                                          : const Color(0xFF172541),
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: CachedNetworkImage(
                                    imageUrl: images[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Product Name
                    Text(
                      product.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // Company
                    Row(
                      children: [
                        const Icon(
                          Icons.business_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            product.company ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Price and Rating
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '\$${product.price ?? 0}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF8B55FF),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Spacer(),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _ratingSummary(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Product Specifications
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071020),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF172541),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _specItem(
                                  Icons.category_outlined,
                                  'Category',
                                  product.category ?? '-',
                                ),
                              ),
                              Expanded(
                                child: _specItem(
                                  Icons.verified_outlined,
                                  'Condition',
                                  product.status ?? '-',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _specItem(
                                  Icons.inventory_2_outlined,
                                  'Stock',
                                  '${product.countInStock ?? 0}',
                                ),
                              ),
                              Expanded(
                                child: _specItem(
                                  Icons.business_outlined,
                                  'Brand',
                                  product.company ?? '-',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Product Description
                    const Text(
                      'Product Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      product.description ??
                          'No description available for this product.',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Reviews
                    _reviewsSection(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Add To Cart
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 58,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add to cart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7040FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Rating Summary
  Widget _ratingSummary() {
    return BlocBuilder<ProductCubit, ProductStates>(
      builder: (context, state) {
        final reviews =
            ProductCubit.get(context).reviewModel?.reviews ?? [];

        double average = 0;

        if (reviews.isNotEmpty) {
          average = reviews.fold<double>(
            0,
                (sum, review) =>
            sum + (double.tryParse('${review.rating}') ?? 0),
          ) /
              reviews.length;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFFFFD84D),
              size: 19,
            ),
            const SizedBox(width: 5),
            Text(
              average.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '(${reviews.length} reviews)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Reviews Section
  Widget _reviewsSection() {
    return BlocBuilder<ProductCubit, ProductStates>(
      builder: (context, state) {
        final reviews =
            ProductCubit.get(context).reviewModel?.reviews ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Customer Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddReviewDialog,
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF8B55FF),
                  ),
                  label: const Text(
                    'Add Review',
                    style: TextStyle(
                      color: Color(0xFF8B55FF),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (state is ErrorGetAllReviews)
              const Text(
                'Could not load reviews.',
                style: TextStyle(color: Colors.white54),
              )
            else if (reviews.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF071020),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF172541),
                  ),
                ),
                child: const Text(
                  'No reviews yet. Be the first to review this product!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              )
            else
              ...reviews.map((review) => _buildReviewItem(review)),
          ],
        );
      },
    );
  }

  // Single Review Item
  Widget _buildReviewItem(ReviewsItems review) {
    final rating = (double.tryParse('${review.rating}') ?? 0)
        .clamp(0, 5)
        .toInt();

    final date = DateTime.tryParse(review.createdAt ?? '');
    final profileImage = review.user?.profileImage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF071020),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF172541),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: const Color(0xFF172541),
                backgroundImage:
                profileImage != null && profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : null,
                child: profileImage == null || profileImage.isEmpty
                    ? const Icon(
                  Icons.person,
                  color: Colors.white70,
                )
                    : null,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user?.name ?? 'Anonymous',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date != null
                          ? DateFormat('dd-MM-yyyy').format(date)
                          : '',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                      (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFF8B55FF),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            review.comment ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Add Review Dialog
  Future<void> _showAddReviewDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _AddReviewDialog(
          onSubmit: (comment, rating) {
            ProductCubit.get(context).addReview(
              widget.product.sId,
              comment,
              rating,
            );
          },
        );
      },
    );
  }

  // Circle Button
  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF0A1428),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF1C2B48),
          ),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 19,
        ),
      ),
    );
  }

  // Product Specifications Item
  Widget _specItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF101C35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF8B55FF),
            size: 17,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Separate Add Review Dialog
class _AddReviewDialog extends StatefulWidget {
  final void Function(String comment, int rating) onSubmit;

  const _AddReviewDialog({
    required this.onSubmit,
  });

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final TextEditingController _commentController = TextEditingController();

  int selectedRating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    final comment = _commentController.text.trim();

    if (comment.isEmpty) {
      return;
    }

    widget.onSubmit(comment, selectedRating);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0E172E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Add Your Review',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rate this product',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        index < selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xFFFFD84D),
                        size: 30,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _commentController,
              maxLines: 4,
              minLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Write your review...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                filled: true,
                fillColor: const Color(0xFF071020),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white54),
          ),
        ),

        ElevatedButton(
          onPressed: _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7040FF),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
