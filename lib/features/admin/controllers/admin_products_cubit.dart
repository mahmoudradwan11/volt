import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/admin/controllers/admin_products_states.dart';
import 'package:volt/features/admin/models/company_model.dart';
import 'package:volt/features/products/models/product_model.dart';

/// Admin product management against the store API:
/// list (GET /product/get/sorted-products, with sales per product),
/// add (POST /product/add), edit (PUT /product/update/:id) and
/// delete (DELETE /product/:id). Added products are live for users
/// immediately because users read the same backend.
class AdminProductsCubit extends Cubit<AdminProductsStates> {
  AdminProductsCubit() : super(AdminProductsInitialState());

  static AdminProductsCubit get(context) => BlocProvider.of(context);

  List<Product> products = [];
  List<CompanyModel> get companies => CompanyModel.fromProducts(products);

  static const categories = [
    'Laptops',
    'Smart Phones',
    'Smart Watches',
    'Smart TVs',
    'PC and laptop accessories',
  ];
  static const statuses = ['New', 'Used'];

  Future<void> loadProducts({bool silent = false}) async {
    if (!silent || products.isEmpty) emit(AdminProductsLoadingState());
    try {
      final value = await DioHelperStore.getData(
        url: ApiConstants.companyProductsSales,
      );
      final list = value.data['products'];
      products = [
        if (list is List)
          for (final v in list)
            if (v is Map<String, dynamic>) Product.fromJson(v),
      ];
      emit(AdminProductsSuccessState());
    } catch (error) {
      print(error.toString());
      emit(AdminProductsErrorState(error.toString()));
    }
  }

  /// Adds a product. [images] are data-URI strings (the API uploads them
  /// to its image host); the first one becomes the main image.
  Future<bool> addProduct({
    required String name,
    required num price,
    required String description,
    required String category,
    required String status,
    required String company,
    required int countInStock,
    required List<String> images,
    double? discountPercent,
  }) async {
    emit(AdminProductSavingState());
    try {
      final offer = _applyOffer(price, description, discountPercent);
      await DioHelperStore.postData(
        url: ApiConstants.addProductApi,
        data: {
          'name': name,
          'price': offer.price,
          'description': offer.description,
          'category': category,
          'status': status,
          'company': company,
          'countInStock': countInStock,
          'image': images.first,
          'images': images.length > 1 ? images.sublist(1) : <String>[],
        },
      );
      showToast('Product added', ToastStates.SUCCESS);
      emit(AdminProductSavedState());
      await loadProducts(silent: true);
      return true;
    } catch (error) {
      print(error.toString());
      showToast('Could not add the product', ToastStates.ERROR);
      emit(AdminProductSaveErrorState(error.toString()));
      return false;
    }
  }

  /// Edits a product. [price] is the regular price; with a
  /// [discountPercent] above 0 the live price becomes the discounted one
  /// and the offer is saved in the description tag. A 0 or empty percent
  /// removes the offer. Images cannot be changed here: the API's update
  /// endpoint ignores image fields.
  Future<bool> updateProduct({
    required Product product,
    required String name,
    required num price,
    required String description,
    required String category,
    required String status,
    required String company,
    required int countInStock,
    double? discountPercent,
  }) async {
    emit(AdminProductSavingState());
    try {
      final offer = _applyOffer(price, description, discountPercent);
      await DioHelperStore.putData(
        url: '${ApiConstants.sellerApi}/update/${product.sId}',
        data: {
          'name': name,
          'price': offer.price,
          'description': offer.description,
          'category': category,
          'status': status,
          'company': company,
          'countInStock': countInStock,
        },
      );
      showToast('Product updated', ToastStates.SUCCESS);
      emit(AdminProductSavedState());
      await loadProducts(silent: true);
      return true;
    } catch (error) {
      print(error.toString());
      showToast('Could not update the product', ToastStates.ERROR);
      emit(AdminProductSaveErrorState(error.toString()));
      return false;
    }
  }

  Future<bool> deleteProduct(Product product) async {
    try {
      await DioHelperStore.delData(
        url: '${ApiConstants.sellerApi}/${product.sId}',
      );
      products.removeWhere((p) => p.sId == product.sId);
      showToast('Product deleted', ToastStates.SUCCESS);
      emit(AdminProductDeletedState());
      emit(AdminProductsSuccessState());
      return true;
    } catch (error) {
      print(error.toString());
      showToast('Could not delete the product', ToastStates.ERROR);
      return false;
    }
  }

  ({num price, String description}) _applyOffer(
    num regularPrice,
    String description,
    double? percent,
  ) {
    final clean = description.replaceFirst(Product.offerTag, '').trimRight();
    if (percent == null || percent <= 0) {
      return (price: regularPrice, description: clean);
    }
    final discounted =
        ((regularPrice * (1 - percent / 100)) * 1000).round() / 1000;
    return (
      price: discounted,
      description: '$clean [[offer:$regularPrice:$percent]]',
    );
  }
}
