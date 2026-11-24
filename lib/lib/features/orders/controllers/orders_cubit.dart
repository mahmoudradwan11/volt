import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/features/orders/controllers/orders_states.dart';
import 'package:volt/features/orders/data/orders_database.dart';
import 'package:volt/features/orders/models/order_model.dart';
import 'package:volt/features/products/models/review_model.dart';

class OrdersCubit extends Cubit<OrdersStates> {
  OrdersCubit() : super(OrdersInitialState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  OrdersModel? ordersModel;

  /// Seeds two demo orders the first time the screen opens, so the UI
  /// can be reviewed before a checkout flow exists. Set to false (or
  /// delete `_seedDemoOrders`) once real orders are saved from checkout.
  static const bool seedDemoOrders = true;

  /// Loads the logged-in customer's orders from the local database
  /// (sqflite), newest first, then attaches their product ratings.
  Future<void> getMyOrders() async {
    emit(OrdersLoadingState());
    try {
      final customerId = nationalId ?? '';
      if (seedDemoOrders) await _seedDemoOrders(customerId);
      final orders = await OrdersDatabase.instance.getOrders(customerId);
      ordersModel = OrdersModel(
        status: 'success',
        orders: orders,
      );
      await _attachMyRatings();
      emit(OrdersSuccessState());
    } catch (error) {
      print(error.toString());
      emit(OrdersErrorState(error.toString()));
    }
  }

  /// Call this from the checkout flow when an order is placed, then
  /// reload with getMyOrders().
  Future<void> addOrder(Order order) async {
    try {
      order.nationalId = nationalId;
      await OrdersDatabase.instance.insertOrder(order);
    } catch (error) {
      print(error.toString());
    }
  }

  /// For every ordered product, look up the logged-in customer's review
  /// (reviews are matched by user name, the only user field the reviews
  /// API returns) and attach their rating to the order item.
  Future<void> _attachMyRatings() async {
    final orders = ordersModel?.orders;
    if (orders == null || orders.isEmpty) return;

    final String? myName = await _getMyName();
    if (myName == null) return;

    final productIds = <String>{};
    for (final order in orders) {
      for (final item in order.items ?? <OrderItem>[]) {
        if (item.productId != null) productIds.add(item.productId!);
      }
    }

    final ratingsByProduct = <String, double>{};
    for (final productId in productIds) {
      try {
        final value = await DioHelperStore.getData(
          url: '${ApiConstants.getAllReviewApi}/$productId',
        );
        final reviewModel = ReviewModel.fromJson(value.data);
        for (final review in reviewModel.reviews ?? <ReviewsItems>[]) {
          if (review.user?.name == myName && review.rating != null) {
            ratingsByProduct[productId] = (review.rating as num).toDouble();
            break;
          }
        }
      } catch (error) {
        // A product with no reviews (or a failed fetch) just stays unrated.
        print(error.toString());
      }
    }

    for (final order in orders) {
      for (final item in order.items ?? <OrderItem>[]) {
        item.myRating = ratingsByProduct[item.productId];
      }
    }
  }

  /// The profile endpoint returns the logged-in user's name from their
  /// saved token (same call the profile flow uses).
  Future<String?> _getMyName() async {
    try {
      final String? savedToken = CacheHelper.getData(key: 'token') ?? token;
      if (savedToken == null) return null;
      final value = await DioHelperStore.postData(
        url: ApiConstants.profileApi,
        data: {'token': savedToken},
      );
      return value.data['user']?['name'];
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /// One-time demo seed: two orders built on real products from the live
  /// API so images, prices and review lookups work while reviewing the
  /// screen. Only inserts when this customer has no saved orders yet.
  Future<void> _seedDemoOrders(String customerId) async {
    final existing = await OrdersDatabase.instance.getOrders(customerId);
    if (existing.isNotEmpty) return;

    final demoOrders = [
      Order(
        sId: 'ORD-DEMO-1002',
        nationalId: customerId,
        createdAt: '2026-11-22T19:45:00.000Z',
        status: 'Delivered',
        paymentMethod: 'Visa',
        totalPaid: 530.0,
        items: [
          OrderItem(
            productId: '645f8ffd1489fc879fdf22df',
            name: 'Apple iPhone 13',
            company: 'Apple',
            image:
                'https://res.cloudinary.com/dzh2hde2n/image/upload/v1683984376/gj5qcjhkkudrazysf39j.webp',
            price: 30.0,
            quantity: 1,
          ),
          OrderItem(
            productId: '645f92671489fc879fdf22e8',
            name: 'iPhone 12 mini',
            company: 'Apple',
            image:
                'https://res.cloudinary.com/dzh2hde2n/image/upload/v1683984993/alrgs0pguhztlirye6vd.png',
            price: 500.0,
            quantity: 1,
          ),
        ],
      ),
      Order(
        sId: 'ORD-DEMO-1001',
        nationalId: customerId,
        createdAt: '2026-11-18T14:20:00.000Z',
        status: 'Processing',
        paymentMethod: 'Cash on delivery',
        totalPaid: 67.808,
        items: [
          OrderItem(
            productId: '645f91521489fc879fdf22e2',
            name: 'iPhone 13 Pro Max ',
            company: 'Apple',
            image:
                'https://res.cloudinary.com/dzh2hde2n/image/upload/v1683984705/hsjnjyvxrpod8ytmfs9l.webp',
            price: 33.904,
            quantity: 2,
          ),
        ],
      ),
    ];

    for (final order in demoOrders) {
      await OrdersDatabase.instance.insertOrder(order);
    }
  }
}
