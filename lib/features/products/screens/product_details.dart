import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/features/products/models/product_model.dart';

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

    final bool isUsed =
        product.status?.toLowerCase() == 'used';

    return Scaffold(
      backgroundColor:  HexColor('#0E172E').withValues(alpha: 0.8),

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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                          // Glow
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

                                  errorWidget:
                                      (context, url, error) {
                                    return const Center(
                                      child: Icon(
                                        Icons
                                            .image_not_supported_outlined,
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
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isUsed
                                    ? const Color(0xFF30374D)
                                    : const Color(0xFF7040FF),
                                borderRadius:
                                BorderRadius.circular(10),
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

                          // =========================
                          // Dots
                          // =========================

                          Positioned(
                            bottom: 18,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                    (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    margin:
                                    const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    height: 6,
                                    width: currentImage == index
                                        ? 18
                                        : 6,
                                    decoration: BoxDecoration(
                                      color:
                                      currentImage == index
                                          ? const Color(
                                        0xFF8B55FF,
                                      )
                                          : Colors.white30,
                                      borderRadius:
                                      BorderRadius.circular(10),
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
                              final bool selected =
                                  currentImage == index;

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
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0B1530),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(
                                        0xFF7040FF,
                                      )
                                          : const Color(
                                        0xFF172541,
                                      ),
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  padding:
                                  const EdgeInsets.all(5),
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
                        Text(
                          product.company ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Row(
                      children: [

                        Text(
                          '\$${product.price ?? 0}',
                          style: const TextStyle(
                            color: Color(0xFF8B55FF),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD84D),
                          size: 19,
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          '4.8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          '(124 reviews)',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16,
          ),
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
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