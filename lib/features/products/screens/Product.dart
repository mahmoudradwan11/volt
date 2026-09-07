import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:volt/core/Widgets/text_form_feild.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/home/controllers/user_home_states.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/core/constants/icon_broken.dart';
import 'package:volt/core/constants/app_images.dart';
import 'package:volt/core/constants/app_strings.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/controllers/product_states.dart';
import 'package:volt/features/products/data/product_cate_list.dart';
import 'package:volt/features/products/widgets/build_user_product_home_cate_item.dart';
import 'package:volt/features/products/widgets/product_section.dart';
class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..getProducts('Laptops'),
      child: BlocConsumer<ProductCubit, ProductStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ProductCubit  cubit= ProductCubit.get(context);
          if(cubit.productModel==null){
            return  Scaffold(
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
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(IconBroken.Buy, color: AppColors.whiteColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(AppImages.splash),
                      backgroundColor: AppColors.circleAvatarBackHomeColor,
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:HexColor('#0E172E'),
                                border: Border.all(color: HexColor('#603FF8').withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(15)),
                            height: 55,
                            child: Center(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    prefixIcon: const Icon(
                                      Icons.search_outlined,
                                      color: Colors.white,
                                    )
                                ),
                                onSubmitted:(value){
                                  //  cubit.search(value);
                                  //  navigateTo(context,const SearchScreen());
                                },
                              ),
                            ),
                          ),
                        ),
                      BlocConsumer<UserHomeCubit, UserHomeStates>(
                  listener: (BuildContext context, UserHomeStates state) {},
                  builder: (BuildContext context, UserHomeStates state) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 90,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              buildCateItem(
                                userHomeCateModel[index],
                                index,
                                context,
                              ),
                          separatorBuilder: (context, index) =>
                          const SizedBox(width: 1),
                          itemCount: userHomeCateModel.length,
                        ),
                      ),);
                  },
                  ),
                Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 20,
                ),
                ),
                  ]
                  ),
                ),
              )
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
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.circleAvatarBackHomeColor,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(IconBroken.Buy, color: AppColors.whiteColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(AppImages.splash),
                      backgroundColor: AppColors.circleAvatarBackHomeColor,
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
                            color:HexColor('#0E172E'),
                            border: Border.all(color: HexColor('#603FF8').withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(15)),
                        height: 55,
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                prefixIcon: const Icon(
                                  Icons.search_outlined,
                                  color: Colors.white,
                                )
                            ),
                            onSubmitted:(value){
                            //  cubit.search(value);
                            //  navigateTo(context,const SearchScreen());
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      BlocConsumer<UserHomeCubit, UserHomeStates>(
                        listener: (BuildContext context, UserHomeStates state) {},
                        builder: (BuildContext context, UserHomeStates state) {
                          return Container(
                            height: 90,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildCateItem(
                                    userHomeCateModel[index],
                                    index,
                                    context,
                                  ),
                              separatorBuilder: (context, index) =>
                              const SizedBox(width:10),
                              itemCount: userHomeCateModel.length,
                            ),
                          );
                        },
                          ),
                      SizedBox(height: 10,),
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors:[
                            color2,
                            color1,
                          ])
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
                                      Text('MacBook Pro M',style: TextStyle(color: Colors.white,
                                          fontSize: AppFontsSize.fontSize20,
                                          fontWeight: FontWeight.bold),),
                                      Text('Apple',style: TextStyle(color: Colors.grey,
                                                            fontSize: AppFontsSize.fontSize14,
                                                            fontWeight: FontWeight.normal),),
                                      Text('1299\$',style: TextStyle(color: Colors.indigo,
                                          fontSize: AppFontsSize.fontSize20,
                                          fontWeight: FontWeight.bold),),
                                      DefaultButton(buttonWidget: Text('View'.toUpperCase(),style: TextStyle(color: Colors.white),), function:(){},backgroundColor: color1.withValues(alpha: 0.5),width: 100,)

                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                    child: Image(image: AssetImage('assests/images/mac.png'),width: double.infinity,height: 150,fit: BoxFit.cover,)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ProductSection(
                        title: 'Trending Products',
                        products: cubit.productModel!.laptopNewProduct,
                      ),
                      SizedBox(height: 10,),
                      ProductSection(
                        title: 'Trending Products',
                        products: cubit.productModel!.phoneNewProduct,
                      ),
                      ProductSection(
                        title: 'Trending Products',
                        products: cubit.productModel!.smartTvsNewProduct,
                      ),
                      SizedBox(height: 10,),
                      ProductSection(
                        title: 'Used Products',
                        products: cubit.productModel!.laptopUsedProduct,
                      ),
                      SizedBox(height: 10,),
                      ProductSection(
                        title: 'Used Products',
                        products: cubit.productModel!.phoneUsedProduct,
                      ),
                      SizedBox(height: 10,),
                      ProductSection(
                        title: 'Used Products',
                        products: cubit.productModel!.smartTvsUsedProduct,
                      ),
                      ProductSection(
                        title: 'Trending Products',
                        products: cubit.productModel!.pcAccessAllProduct,
                      ),
                      ProductSection(
                        title: 'Trending Products',
                        products: cubit.productModel!.smartWatchAllProduct,
                      ),
                    ]
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
