import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/orders/controllers/orders_cubit.dart';
import 'package:volt/features/orders/controllers/orders_states.dart';
import 'package:volt/features/orders/models/order_model.dart';
import 'package:volt/features/orders/widgets/build_order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  /// The shared app-level OrdersCubit (registered in main.dart), or null
  /// when this screen is opened in a tree that doesn't have it.
  static OrdersCubit? _rootCubit(BuildContext context) {
    try {
      return context.read<OrdersCubit>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normal case: main.dart's MultiBlocProvider supplies one shared
    // OrdersCubit, the same instance the product BUY buttons write to.
    if (_rootCubit(context) != null) {
      return const _OrdersView();
    }
    // Fallback for a tree missing the root provider (for example a
    // project the feature was merged into without the main.dart change):
    // provide a local instance so the screen still opens. Orders persist
    // in sqflite, so bought orders still show up here.
    return BlocProvider(
      create: (_) => OrdersCubit(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  // Age filter: 0 = All, then one per OrderAgeCategory.
  int selectedFilter = 0;
  static const filterLabels = ['All', 'New', 'Last 24 hours', 'Old'];

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: BlocBuilder<OrdersCubit, OrdersStates>(
        builder: (context, state) {
          var cubit = OrdersCubit.get(context);

          if (state is OrdersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.subTextColor, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong loading your orders',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  MaterialButton(
                    color: AppColors.defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => cubit.getMyOrders(),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            );
          }

          final orders = cubit.ordersModel?.orders ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded,
                      color: AppColors.borderColor, size: 56),
                  SizedBox(height: 12),
                  Text(
                    'No orders yet',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          final visible = orders.where((order) {
            switch (selectedFilter) {
              case 1:
                return order.ageCategory == OrderAgeCategory.fresh;
              case 2:
                return order.ageCategory == OrderAgeCategory.last24Hours;
              case 3:
                return order.ageCategory == OrderAgeCategory.old;
              default:
                return true;
            }
          }).toList();

          return Column(
            children: [
              SizedBox(
                height: 54,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: filterLabels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) =>
                      _buildFilterChip(index),
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Text(
                          'No orders in this category',
                          style:
                              TextStyle(color: AppColors.subTextColor, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: visible.length,
                        itemBuilder: (context, index) =>
                            BuildOrderCard(order: visible[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(int index) {
    final bool selected = selectedFilter == index;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC8DE22) : AppColors.circleAvatarBackHomeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            filterLabels[index],
            style: TextStyle(
              color: selected ? const Color(0xFF010610) : AppColors.subTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
