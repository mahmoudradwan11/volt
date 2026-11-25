import 'package:volt/features/products/models/product_model.dart';

/// A supplier company with its products, built from the product list.
class CompanyModel {
  final String name;
  final List<Product> products;
  CompanyModel(this.name, this.products);

  int get productCount => products.length;
  int get totalSales => products.fold(0, (sum, p) => sum + p.sales);

  /// Groups products by company name. Names are trimmed and compared
  /// ignoring case, so "Apple" and "Apple " are one company.
  static List<CompanyModel> fromProducts(List<Product> products) {
    final map = <String, List<Product>>{};
    final display = <String, String>{};
    for (final p in products) {
      final raw = (p.company ?? '').trim();
      if (raw.isEmpty) continue;
      final key = raw.toLowerCase();
      display.putIfAbsent(key, () => raw);
      map.putIfAbsent(key, () => []).add(p);
    }
    final list = [
      for (final e in map.entries) CompanyModel(display[e.key]!, e.value),
    ];
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }
}
