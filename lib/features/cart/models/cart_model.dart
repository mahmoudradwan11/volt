/// Cart data as the backend returns it from GET /cart/allProducts:
/// every entry is a full product object plus the customer's chosen
/// quantity and the line total (price * quantity).
class CartModel {
  List<CartProduct>? products;

  CartModel({this.products});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <CartProduct>[];
      json['products'].forEach((v) {
        products!.add(CartProduct.fromJson(v));
      });
    }
  }
}

class CartProduct {
  String? sId;
  String? status;
  String? category;
  String? name;
  dynamic price;
  String? description;
  String? image;
  String? company;
  int? quantity;
  dynamic totalPrice;

  CartProduct({
    this.sId,
    this.status,
    this.category,
    this.name,
    this.price,
    this.description,
    this.image,
    this.company,
    this.quantity,
    this.totalPrice,
  });

  CartProduct.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
    category = json['category'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    image = json['image'];
    company = json['company'];
    quantity = json['quantity'];
    totalPrice = json['totalPrice'];
  }

  /// price * quantity for this line, computed locally so the total on
  /// screen never waits on the API's totalPrice field.
  double get lineTotal =>
      ((price as num?)?.toDouble() ?? 0) * (quantity ?? 0);
}
