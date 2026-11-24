import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/features/category/controllers/category_states.dart';
import 'package:volt/features/products/data/product_cate_list.dart';
import 'package:volt/features/products/models/product_model.dart';

/// Loads every product category with its products from the store API
/// (GET /product/inCart/:category, the same endpoint the home screen
/// uses) and searches products by keyword (GET /product/get/search).
class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitialState());

  static CategoryCubit get(context) => BlocProvider.of(context);

  /// Category API name -> all its products (new and used combined).
  Map<String, List<Product>> productsByCategory = {};

  /// Keyword search results. null means the user is not searching, so
  /// the categories grid shows; a list (even empty) shows results.
  List<Product>? searchResults;

  /// True while a search request is in flight, for the inline spinner.
  bool searching = false;

  int categoryCount(String apiCategory) =>
      productsByCategory[apiCategory]?.length ?? 0;

  void getCategories() {
    emit(CategoryLoadingState());
    _loadAllCategories();
  }

  Future<void> _loadAllCategories() async {
    try {
      for (final cate in userHomeCateModel) {
        final value = await DioHelperStore.getData(
          url: '${ApiConstants.homeProductsApi}${cate.apiCategory}',
          data: {'nationalId': nationalId},
        );
        final products = <Product>[];
        final list = value.data['products'];
        if (list is List) {
          for (final v in list) {
            if (v is Map<String, dynamic>) products.add(Product.fromJson(v));
          }
        }
        productsByCategory[cate.apiCategory] = products;
      }
      emit(CategorySuccessState());
    } catch (error) {
      print(error.toString());
      emit(CategoryErrorState(error.toString()));
    }
  }

  /// Searches all products by keyword. An empty keyword clears the
  /// search and brings the categories grid back.
  void search(String keyword) {
    if (keyword.trim().isEmpty) {
      searchResults = null;
      searching = false;
      emit(CategorySuccessState());
      return;
    }
    searching = true;
    emit(CategorySuccessState());
    DioHelperStore.getData(
      url: ApiConstants.searchApi,
      data: {'keyword': keyword.trim()},
    ).then((value) {
      final list = value.data['products'];
      searchResults = <Product>[
        if (list is List)
          for (final v in list)
            if (v is Map<String, dynamic>) Product.fromJson(v),
      ];
      searching = false;
      emit(CategorySuccessState());
    }).catchError((error) {
      print(error.toString());
      searchResults = <Product>[];
      searching = false;
      emit(CategorySuccessState());
    });
  }
}
