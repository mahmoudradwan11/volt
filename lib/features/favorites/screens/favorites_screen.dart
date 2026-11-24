import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/favorites/controllers/favorite_cubit.dart';
import 'package:volt/features/favorites/controllers/favorite_states.dart';
import 'package:volt/features/products/widgets/build_product_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  /// The shared app-level FavoriteCubit (registered in main.dart), or
  /// null when this screen is opened in a tree that doesn't have it.
  static FavoriteCubit? _rootCubit(BuildContext context) {
    try {
      return context.read<FavoriteCubit>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normal case: main.dart's MultiBlocProvider supplies the cubit.
    if (_rootCubit(context) != null) {
      return const _FavoritesView();
    }
    // Fallback for a tree missing the root provider (for example a
    // project the feature was merged into without the main.dart change):
    // provide a local instance so the screen still opens.
    return BlocProvider(
      create: (_) => FavoriteCubit(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatefulWidget {
  const _FavoritesView();

  @override
  State<_FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<_FavoritesView> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor,
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteStates>(
        builder: (context, state) {
          final cubit = FavoriteCubit.get(context);
          final products = cubit.favoriteProducts;

          if (state is FavoriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.subTextColor, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong loading your wishlist',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  MaterialButton(
                    color: AppColors.defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => cubit.getFavorites(),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            );
          }

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.borderColor,
                    size: 64,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: AppColors.subTextColor, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 160 / 200,
            ),
            itemBuilder: (context, index) =>
                BuildProductItem(productModel: products[index]),
          );
        },
      ),
    );
  }
}
