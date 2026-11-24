import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/home/controllers/user_home_states.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/controllers/product_states.dart';
import 'package:volt/features/products/data/product_cate_list.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/widgets/build_user_product_home_cate_item.dart';
import 'package:volt/features/products/widgets/product_section.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProductCubit cubit = ProductCubit.get(context);
        if (cubit.productModel == null) {
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(AppImages.splash),
                  backgroundColor: Colors.transparent,
                ),
              ),
              title: Text(AppStrings.appTitle.toUpperCase()),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child:  InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1428),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1C2B48),
                          ),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColors.whiteColor,
                          size: 19,
                        ),
                      ),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: AppColors.circleAvatarBackHomeColor,
                      child:  InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1428),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1C2B48),
                            ),
                          ),
                          child: Icon(
                            IconBroken.Buy,
                            color: AppColors.whiteColor,
                            size: 19,
                          ),
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: AppColors.circleAvatarBackHomeColor,
                      child:  InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1428),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1C2B48),
                            ),
                          ),
                          child: Icon(
                            IconBroken.Notification,
                            color: AppColors.whiteColor,
                            size: 19,
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.p2Color,
                        border: Border.all(
                          color: AppColors.p3Color.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 55,
                      child: Center(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            prefixIcon: const Icon(
                              Icons.search_outlined,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          onSubmitted: (value) {
                            //  cubit.search(value);
                            //  navigateTo(context,const SearchScreen());
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlocConsumer<UserHomeCubit, UserHomeStates>(
                      listener:
                          (BuildContext context, UserHomeStates state) {},
                      builder: (BuildContext context, UserHomeStates state) {
                        return Container(
                          height: 90,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => buildCateItem(
                              userHomeCateModel[index],
                              index,
                              context,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemCount: userHomeCateModel.length,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [AppColors.p2Color, AppColors.p3Color],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Center(
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'MacBook Pro M',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFontsSize.fontSize20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Apple',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: AppFontsSize.fontSize14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      '1299\$',
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: AppFontsSize.fontSize20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DefaultButton(
                                      buttonWidget: Text(
                                        'View'.toUpperCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      function: () {},
                                      backgroundColor: AppColors.p2Color
                                          .withValues(alpha: 0.5),
                                      width: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Image(
                                  image: AssetImage('assests/images/mac.png'),
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(AppImages.splash),
                backgroundColor: Colors.transparent,
              ),
            ),
            title: Text(AppStrings.appTitle.toUpperCase()),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child:  InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1428),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1C2B48),
                          ),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColors.whiteColor,
                          size: 19,
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child:  InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1428),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1C2B48),
                          ),
                        ),
                        child: Icon(
                          IconBroken.Buy,
                          color: AppColors.whiteColor,
                          size: 19,
                        ),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child:  InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1428),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1C2B48),
                          ),
                        ),
                        child: Icon(
                          IconBroken.Notification,
                          color: AppColors.whiteColor,
                          size: 19,
                        ),
                      ),
                    )
                ),
              ),

            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.p2Color,
                      border: Border.all(
                        color: AppColors.p3Color.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 55,
                    child: Center(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        onSubmitted: (value) {
                          //  cubit.search(value);
                          //  navigateTo(context,const SearchScreen());
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocConsumer<UserHomeCubit, UserHomeStates>(
                    listener: (BuildContext context, UserHomeStates state) {},
                    builder: (BuildContext context, UserHomeStates state) {
                      return Container(
                        height: 90,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => buildCateItem(
                            userHomeCateModel[index],
                            index,
                            context,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: userHomeCateModel.length,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [AppColors.p2Color, AppColors.p3Color],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Center(
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MacBook Pro M',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontsSize.fontSize20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Apple',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: AppFontsSize.fontSize14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    '1299\$',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: AppFontsSize.fontSize20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DefaultButton(
                                    buttonWidget: Text(
                                      'View'.toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    function: () {},
                                    backgroundColor: AppColors.p2Color
                                        .withValues(alpha: 0.5),
                                    width: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              child: Image(
                                image: AssetImage('assests/images/mac.png'),
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if(ProductStates is ProductLoadingState)
                    Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  Builder(
                    builder: (context) {
                      final categoryIndex =
                          UserHomeCubit.get(context).currentCategoryIndex;
                      List<Product> newProducts = [];
                      List<Product> usedProducts = [];

                      switch (categoryIndex) {
                      // Laptops
                        case 0:
                          newProducts =
                              cubit.productModel!.laptopNewProduct ?? [];

                          usedProducts =
                              cubit.productModel!.laptopUsedProduct ?? [];
                          break;

                      // Smart Phones
                        case 1:
                          newProducts =
                              cubit.productModel!.phoneNewProduct ?? [];

                          usedProducts =
                              cubit.productModel!.phoneUsedProduct ?? [];
                          break;

                      // Smart Watches
                        case 2:
                          newProducts =
                              cubit.productModel!.smartWatchAllProduct ?? [];

                          usedProducts = [];
                          break;

                      // Smart TVs
                        case 3:
                          newProducts =
                              cubit.productModel!.smartTvsNewProduct ?? [];

                          usedProducts =
                              cubit.productModel!.smartTvsUsedProduct ?? [];
                          break;

                      // Accessories
                        case 4:
                          newProducts =
                              cubit.productModel!.pcAccessAllProduct ?? [];
                          usedProducts = [];
                          break;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ProductSection(
                            title: 'Trending Products',
                            products: newProducts,
                          ),

                          const SizedBox(height: 10),

                          ProductSection(
                            title: 'Used Products',
                            products: usedProducts,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
