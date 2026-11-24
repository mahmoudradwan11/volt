import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/favorites/controllers/favorite_states.dart';
import 'package:volt/features/products/models/product_model.dart';

/// The logged-in customer's favorites, backed by the store API
/// (POST/DELETE/GET /favorite, keyed by nationalId like the cart).
class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitialState());

  static FavoriteCubit get(context) => BlocProvider.of(context);

  /// Product ids currently in the customer's favorites. Authoritative
  /// once [favoritesLoaded] is true; before that the per-product
  /// inFavorite flag from the products API is used.
  final Set<String> favoriteIds = {};
  bool favoritesLoaded = false;

  /// The favorite products themselves, for the Wishlist tab. Loaded
  /// from GET /favorite (full product objects) and kept in sync by the
  /// heart toggle.
  List<Product> favoriteProducts = [];

  bool isFavorite(Product product) {
    final id = product.sId;
    if (id == null) return false;
    if (favoritesLoaded) return favoriteIds.contains(id);
    return product.inFavorite ?? false;
  }

  /// Loads the customer's favorite product ids from the API.
  Future<void> getFavorites() async {
    emit(FavoriteLoadingState());
    try {
      final value = await DioHelperStore.getData(
        url: ApiConstants.favoriteApi,
        data: {'nationalId': nationalId},
      );
      favoriteIds.clear();
      favoriteProducts = [];
      final list = value.data['favoriteProducts'];
      if (list is List) {
        for (final v in list) {
          if (v is Map<String, dynamic> && v['_id'] != null) {
            favoriteIds.add(v['_id']);
            final product = Product.fromJson(v);
            product.inFavorite = true;
            favoriteProducts.add(product);
          }
        }
      }
      favoritesLoaded = true;
      emit(FavoriteSuccessState());
    } catch (error) {
      print(error.toString());
      emit(FavoriteErrorState());
    }
  }

  /// Heart toggle on the product cards: flips the heart right away
  /// (optimistic), then confirms with the API; on a network failure it
  /// flips back and shows a toast.
  Future<void> toggleFavorite(Product product) async {
    final id = product.sId;
    if (id == null) return;

    final wasFavorite = isFavorite(product);
    if (wasFavorite) {
      favoriteIds.remove(id);
      favoriteProducts.removeWhere((p) => p.sId == id);
    } else {
      favoriteIds.add(id);
      if (!favoriteProducts.any((p) => p.sId == id)) {
        favoriteProducts.add(product);
      }
    }
    favoritesLoaded = true;
    product.inFavorite = !wasFavorite;
    emit(FavoriteSuccessState());

    try {
      if (wasFavorite) {
        await DioHelperStore.delData(
          url: ApiConstants.favoriteApi,
          data: {
            'nationalId': nationalId,
            'productId': id,
          },
        );
      } else {
        await DioHelperStore.postData(
          url: ApiConstants.favoriteApi,
          data: {
            'nationalId': nationalId,
            'productId': id,
          },
        );
      }
    } catch (error) {
      print(error.toString());
      // Revert the optimistic flip.
      if (wasFavorite) {
        favoriteIds.add(id);
        if (!favoriteProducts.any((p) => p.sId == id)) {
          favoriteProducts.add(product);
        }
      } else {
        favoriteIds.remove(id);
        favoriteProducts.removeWhere((p) => p.sId == id);
      }
      product.inFavorite = wasFavorite;
      emit(FavoriteSuccessState());
      showToast('Could not update favorites', ToastStates.ERROR);
    }
  }
}
