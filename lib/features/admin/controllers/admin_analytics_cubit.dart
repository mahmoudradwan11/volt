import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/features/admin/controllers/admin_analytics_states.dart';
import 'package:volt/features/admin/models/company_model.dart';
import 'package:volt/features/products/models/product_model.dart';

/// Sales analytics computed from GET /product/get/sorted-products
/// (every product with its total units sold).
class AdminAnalyticsCubit extends Cubit<AdminAnalyticsStates> {
  AdminAnalyticsCubit() : super(AdminAnalyticsInitialState());

  static AdminAnalyticsCubit get(context) => BlocProvider.of(context);

  List<Product> products = [];
  List<CompanyModel> companies = [];

  Product? bestSelling;
  Product? slowestSelling;

  /// How many products share the slowest sales number (often 0 sales).
  int slowestCount = 0;
  CompanyModel? topCompany;
  int totalSales = 0;

  Future<void> load() async {
    emit(AdminAnalyticsLoadingState());
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
      _compute();
      emit(AdminAnalyticsSuccessState());
    } catch (error) {
      print(error.toString());
      emit(AdminAnalyticsErrorState(error.toString()));
    }
  }

  void _compute() {
    companies = CompanyModel.fromProducts(products);
    companies.sort((a, b) => b.productCount.compareTo(a.productCount));
    totalSales = products.fold(0, (s, p) => s + p.sales);
    bestSelling = null;
    slowestSelling = null;
    slowestCount = 0;
    topCompany = null;
    if (products.isEmpty) return;
    final sorted = [...products]..sort((a, b) => b.sales.compareTo(a.sales));
    bestSelling = sorted.first;
    slowestSelling = sorted.last;
    slowestCount = products.where((p) => p.sales == sorted.last.sales).length;
    final byCompany = [...companies]
      ..sort((a, b) => b.totalSales.compareTo(a.totalSales));
    topCompany = byCompany.first;
  }
}
