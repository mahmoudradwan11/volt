import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/orders/controllers/orders_cubit.dart';
import 'package:volt/features/orders/controllers/orders_states.dart';
import 'package:volt/features/orders/models/order_model.dart';
import 'package:volt/features/orders/widgets/build_order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
                  const Icon(Icons.error_outline,
                      color: Colors.white38, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Something went wrong loading your orders',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  MaterialButton(
                    color: AppColors.defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => cubit.getMyOrders(),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final orders = cubit.ordersModel?.orders ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded,
                      color: Colors.white24, size: 56),
                  SizedBox(height: 12),
                  Text(
                    'No orders yet',
                    style: TextStyle(color: Colors.white60, fontSize: 15),
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
                    ? const Center(
                        child: Text(
                          'No orders in this category',
                          style:
                              TextStyle(color: Colors.white38, fontSize: 14),
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
          color: selected ? const Color(0xFFC8DE22) : const Color(0xFF151721),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            filterLabels[index],
            style: TextStyle(
              color: selected ? const Color(0xFF010610) : Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
