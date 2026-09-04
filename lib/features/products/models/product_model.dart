class ProductModel {
  String? status;
  String? message;

  List<Product>? laptopNewProduct;
  List<Product>? laptopUsedProduct;

  List<Product>? phoneNewProduct;
  List<Product>? phoneUsedProduct;

  List<Product>? smartTvsNewProduct;
  List<Product>? smartTvsUsedProduct;

  List<Product>? smartWatchAllProduct;
  List<Product>? pcAccessAllProduct;

  ProductModel({
    this.status,
    this.message,
    this.laptopNewProduct,
    this.laptopUsedProduct,
    this.phoneNewProduct,
    this.phoneUsedProduct,
    this.smartTvsNewProduct,
    this.smartTvsUsedProduct,
    this.smartWatchAllProduct,
    this.pcAccessAllProduct,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    final products = json['products'];

    if (products != null && products is List) {
      laptopNewProduct = [];
      laptopUsedProduct = [];

      phoneNewProduct = [];
      phoneUsedProduct = [];

      smartTvsNewProduct = [];
      smartTvsUsedProduct = [];

      smartWatchAllProduct = [];
      pcAccessAllProduct = [];

      for (final v in products) {
        if (v is! Map<String, dynamic>) continue;

        final product = Product.fromJson(v);

        if (v['category'] == 'PC and laptop accessories') {
          pcAccessAllProduct!.add(product);
        } else if (v['category'] == 'Smart Watches') {
          smartWatchAllProduct!.add(product);
        } else if (v['status'] == 'New') {
          if (v['category'] == 'Laptops') {
            laptopNewProduct!.add(product);
          } else if (v['category'] == 'Smart Phones') {
            phoneNewProduct!.add(product);
          } else if (v['category'] == 'Smart TVs') {
            smartTvsNewProduct!.add(product);
          }
        } else if (v['status'] == 'Used') {
          if (v['category'] == 'Laptops') {
            laptopUsedProduct!.add(product);
          } else if (v['category'] == 'Smart Phones') {
            phoneUsedProduct!.add(product);
          } else if (v['category'] == 'Smart TVs') {
            smartTvsUsedProduct!.add(product);
          }
        }
      }
    }
  }
}

class Product {
  String? sId;
  String? status;
  String? category;
  String? name;
  dynamic price;
  String? description;
  String? image;
  String? company;
  dynamic countInStock;
  dynamic iV;

  List<String>? images;

  bool? inCart;
  bool? inFavorite;

  Product({
    this.sId,
    this.status,
    this.category,
    this.name,
    this.price,
    this.description,
    this.image,
    this.company,
    this.images,
    this.countInStock,
    this.iV,
    this.inCart,
    this.inFavorite,
  });

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
    category = json['category'];
    name = json['name'];
    price = json['price'];

    images = json['images'] != null ? List<String>.from(json['images']) : null;

    description = json['description'];
    image = json['image'];
    company = json['company'];
    countInStock = json['countInStock'];
    iV = json['__v'];

    // لو الـ API رجع null هتفضل null
    inCart = json['inCart'];
    inFavorite = json['inFavorites'];
  }
}
