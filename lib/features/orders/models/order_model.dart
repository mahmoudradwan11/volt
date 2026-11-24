/// Age bucket of an order, computed from its timestamp, so orders move
/// categories automatically as time passes:
/// fresh = placed within the last hour, last24Hours = past an hour but
/// within 24 hours, old = more than 24 hours.
enum OrderAgeCategory { fresh, last24Hours, old }

extension OrderAge on Order {
  OrderAgeCategory get ageCategory {
    final date = DateTime.tryParse(createdAt ?? '');
    if (date == null) return OrderAgeCategory.old;
    final age = DateTime.now().toUtc().difference(date.toUtc());
    if (age.inHours < 1) return OrderAgeCategory.fresh;
    if (age.inHours < 24) return OrderAgeCategory.last24Hours;
    return OrderAgeCategory.old;
  }

  String get ageCategoryLabel {
    switch (ageCategory) {
      case OrderAgeCategory.fresh:
        return 'New';
      case OrderAgeCategory.last24Hours:
        return 'Last 24 hours';
      case OrderAgeCategory.old:
        return 'Old';
    }
  }
}

class OrdersModel {
  String? status;
  String? message;
  List<Order>? orders;

  OrdersModel({this.status, this.message, this.orders});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
  }
}

class Order {
  String? sId;
  String? nationalId;
  String? createdAt;
  String? status;
  String? paymentMethod;
  double? totalPaid;
  List<OrderItem>? items;

  Order({
    this.sId,
    this.nationalId,
    this.createdAt,
    this.status,
    this.paymentMethod,
    this.totalPaid,
    this.items,
  });

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nationalId = json['nationalId'];
    createdAt = json['createdAt'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];
    totalPaid = (json['totalPaid'] as num?)?.toDouble();
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }
  }

  /// Row shape for the local orders table (sqflite).
  /// Items live in their own table, keyed by orderId.
  Map<String, dynamic> toMap() {
    return {
      'id': sId,
      'nationalId': nationalId,
      'createdAt': createdAt,
      'status': status,
      'paymentMethod': paymentMethod,
      'totalPaid': totalPaid,
    };
  }

  Order.fromMap(Map<String, dynamic> map) {
    sId = map['id'];
    nationalId = map['nationalId'];
    createdAt = map['createdAt'];
    status = map['status'];
    paymentMethod = map['paymentMethod'];
    totalPaid = (map['totalPaid'] as num?)?.toDouble();
    items = <OrderItem>[];
  }
}

class OrderItem {
  String? productId;
  String? name;
  String? company;
  String? image;
  double? price;
  int? quantity;

  /// Not stored in the orders tables. Filled in by OrdersCubit from the
  /// reviews API (the logged-in customer's rating on this product).
  double? myRating;

  OrderItem({
    this.productId,
    this.name,
    this.company,
    this.image,
    this.price,
    this.quantity,
    this.myRating,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    productId = json['product'];
    name = json['name'];
    company = json['company'];
    image = json['image'];
    price = (json['price'] as num?)?.toDouble();
    quantity = json['quantity'];
  }

  Map<String, dynamic> toMap(String orderId) {
    return {
      'orderId': orderId,
      'productId': productId,
      'name': name,
      'company': company,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  OrderItem.fromMap(Map<String, dynamic> map) {
    productId = map['productId'];
    name = map['name'];
    company = map['company'];
    image = map['image'];
    price = (map['price'] as num?)?.toDouble();
    quantity = map['quantity'];
  }
}
