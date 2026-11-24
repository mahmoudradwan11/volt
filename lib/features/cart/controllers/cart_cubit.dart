import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/cart/controllers/cart_states.dart';
import 'package:volt/features/cart/models/cart_model.dart';

/// Talks to the backend cart API (https://elwekala.onrender.com/cart).
/// The cart is per customer: every call sends the logged-in customer's
/// nationalId, so each user gets their own server-side cart.
class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());

  static CartCubit get(context) => BlocProvider.of(context);

  CartModel? cartModel;

  /// The item currently being updated on the server, so the cart screen
  /// can show a small spinner on that row only, instead of hiding the
  /// whole screen behind a full-page loader.
  String? updatingProductId;

  /// Total of the whole cart, computed locally from the loaded items.
  double get totalPrice {
    double total = 0;
    for (final product in cartModel?.products ?? <CartProduct>[]) {
      total += product.lineTotal;
    }
    return total;
  }

  int get itemCount {
    int count = 0;
    for (final product in cartModel?.products ?? <CartProduct>[]) {
      count += product.quantity ?? 0;
    }
    return count;
  }

  /// First load of the cart: the only call that shows the full-screen
  /// loading state.
  void getCart() {
    emit(CartLoadingState());
    DioHelperStore.getData(
      url: ApiConstants.getMyCartApi,
      data: {'nationalId': nationalId},
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      emit(CartSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CartErrorState(error.toString()));
    });
  }

  /// Quiet reload after a mutation: no loading state, so the screen
  /// content stays visible while the new cart downloads. On failure the
  /// previously loaded items stay on screen.
  Future<void> _refreshCart() async {
    try {
      final value = await DioHelperStore.getData(
        url: ApiConstants.getMyCartApi,
        data: {'nationalId': nationalId},
      );
      cartModel = CartModel.fromJson(value.data);
    } catch (error) {
      print(error.toString());
      showToast('Could not refresh cart', ToastStates.ERROR);
    } finally {
      updatingProductId = null;
      emit(CartSuccessState());
    }
  }

  /// Adds one unit of a product to the cart. Adding a product that is
  /// already in the cart increases its quantity on the backend.
  Future<void> addToCart(String productId) async {
    updatingProductId = productId;
    emit(CartSuccessState());
    try {
      await DioHelperStore.postData(
        url: ApiConstants.addToCartApi,
        data: {
          'nationalId': nationalId,
          'productId': productId,
          'quantity': 1,
        },
      );
      showToast('Added to cart', ToastStates.SUCCESS);
    } catch (error) {
      print(error.toString());
      showToast('Could not add to cart', ToastStates.ERROR);
    }
    await _refreshCart();
  }

  /// Sets the exact quantity of a cart item. The row stays on screen
  /// with a small inline spinner while the update runs.
  Future<void> updateQuantity(String productId, int quantity) async {
    updatingProductId = productId;
    emit(CartSuccessState());
    try {
      await DioHelperStore.putData(
        url: ApiConstants.updateQuantityApi,
        data: {
          'nationalId': nationalId,
          'productId': productId,
          'quantity': quantity,
        },
      );
    } catch (error) {
      print(error.toString());
      showToast('Could not update quantity', ToastStates.ERROR);
    }
    await _refreshCart();
  }

  /// The minus button at quantity 1 removes the item.
  void decreaseQuantity(CartProduct product) {
    final current = product.quantity ?? 1;
    if (current <= 1) {
      removeFromCart(product.sId);
    } else {
      updateQuantity(product.sId!, current - 1);
    }
  }

  Future<void> removeFromCart(String? productId) async {
    if (productId == null) return;
    updatingProductId = productId;
    emit(CartSuccessState());
    try {
      await DioHelperStore.delData(
        url: ApiConstants.deleteCartApi,
        data: {
          'nationalId': nationalId,
          'productId': productId,
        },
      );
      showToast('Removed from cart', ToastStates.SUCCESS);
    } catch (error) {
      print(error.toString());
      showToast('Could not remove item', ToastStates.ERROR);
    }
    await _refreshCart();
  }

  /// Empties the server cart after an order is placed, one delete call
  /// per item (the API has no clear-all route).
  Future<void> clearCart() async {
    final ids = <String>[
      for (final product in cartModel?.products ?? <CartProduct>[])
        if (product.sId != null) product.sId!,
    ];
    for (final id in ids) {
      try {
        await DioHelperStore.delData(
          url: ApiConstants.deleteCartApi,
          data: {
            'nationalId': nationalId,
            'productId': id,
          },
        );
      } catch (error) {
        print(error.toString());
      }
    }
    await _refreshCart();
  }
}
