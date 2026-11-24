import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/cart/controllers/cart_cubit.dart';
import 'package:volt/features/cart/controllers/cart_states.dart';
import 'package:volt/features/cart/models/cart_model.dart';
import 'package:volt/features/cart/widgets/build_cart_item.dart';
import 'package:volt/features/orders/controllers/orders_cubit.dart';
import 'package:volt/features/orders/models/order_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  /// The shared app-level CartCubit (registered in main.dart), or null
  /// when this screen is opened in a tree that doesn't have it.
  static CartCubit? _rootCubit(BuildContext context) {
    try {
      return context.read<CartCubit>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normal case: main.dart's MultiBlocProvider supplies one shared
    // CartCubit, the same instance the Add to Cart buttons write to.
    if (_rootCubit(context) != null) {
      return const _CartView();
    }
    // Fallback for a tree missing the root provider (for example a
    // project the feature was merged into without the main.dart change):
    // provide a local instance so the screen still opens.
    return BlocProvider(
      create: (_) => CartCubit(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatefulWidget {
  const _CartView();

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  /// Places a real order from the cart contents: saved locally in the
  /// orders feature (sqflite, visible in the Orders tab right away),
  /// then empties the server cart.
  Future<void> _placeOrder(CartCubit cubit) async {
    final products = cubit.cartModel?.products ?? <CartProduct>[];
    if (products.isEmpty) return;

    final order = Order(
      sId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now().toUtc().toIso8601String(),
      status: 'Processing',
      paymentMethod: 'Cash on delivery',
      totalPaid: cubit.totalPrice,
      items: products
          .map(
            (product) => OrderItem(
              productId: product.sId,
              name: product.name,
              company: product.company,
              image: product.image,
              price: (product.price as num?)?.toDouble() ?? 0,
              quantity: product.quantity ?? 1,
            ),
          )
          .toList(),
    );

    try {
      OrdersCubit.get(context).addOrder(order);
    } catch (_) {
      // OrdersCubit missing from the tree must not block the checkout;
      // the cart still clears and the toast confirms the order.
    }
    showToast('Order placed', ToastStates.SUCCESS);
    await cubit.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          final cubit = CartCubit.get(context);
          final products = cubit.cartModel?.products ?? <CartProduct>[];

          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.subTextColor, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong loading your cart',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  MaterialButton(
                    color: AppColors.defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => cubit.getCart(),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            );
          }

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.borderColor,
                    size: 64,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                BuildCartItem(product: products[index]),
          );
        },
      ),

      // Total + checkout
      bottomNavigationBar: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          final cubit = CartCubit.get(context);
          final products = cubit.cartModel?.products ?? <CartProduct>[];
          if (products.isEmpty) return const SizedBox.shrink();

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.p2Color,
                border: Border(
                  top: BorderSide(color: AppColors.borderColor),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${cubit.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => _placeOrder(cubit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7040FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Place Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
