import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/admin/controllers/admin_analytics_cubit.dart';
import 'package:volt/features/admin/controllers/admin_analytics_states.dart';

/// Admin "Analytics" tab: best / slowest selling product, companies with
/// their product counts and the top-selling company.
class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminAnalyticsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.subTextColor),
            onPressed: () => context.read<AdminAnalyticsCubit>().load(),
          ),
        ],
      ),
      body: BlocBuilder<AdminAnalyticsCubit, AdminAnalyticsStates>(
        builder: (context, state) {
          final cubit = AdminAnalyticsCubit.get(context);
          if (state is AdminAnalyticsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminAnalyticsErrorState) {
            return Center(
              child: TextButton(
                onPressed: () => cubit.load(),
                child: const Text('Could not load. Tap to retry'),
              ),
            );
          }
          if (cubit.products.isEmpty) {
            return Center(
              child: Text(
                'No data',
                style: TextStyle(color: AppColors.subTextColor),
              ),
            );
          }
          final best = cubit.bestSelling!;
          final slow = cubit.slowestSelling!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Products',
                      '${cubit.products.length}',
                      Icons.inventory_2_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      'Units sold',
                      '${cubit.totalSales}',
                      Icons.shopping_bag_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _highlight(
                'Best-selling product',
                (best.name ?? '').trim(),
                '${best.sales} sold',
                Icons.trending_up_rounded,
                Colors.green,
              ),
              _highlight(
                'Slowest-selling product',
                (slow.name ?? '').trim(),
                cubit.slowestCount > 1
                    ? '${slow.sales} sold (${cubit.slowestCount} products tied)'
                    : '${slow.sales} sold',
                Icons.trending_down_rounded,
                Colors.redAccent,
              ),
              _highlight(
                'Top-selling company',
                cubit.topCompany!.name,
                '${cubit.topCompany!.totalSales} units sold',
                Icons.emoji_events_outlined,
                AppColors.limeColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Companies and their products',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              for (final c in cubit.companies)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.p2Color,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                      Text(
                        '${c.productCount} products · ${c.totalSales} sold',
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.p3Color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _highlight(
    String title,
    String name,
    String detail,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.p2Color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(detail, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
