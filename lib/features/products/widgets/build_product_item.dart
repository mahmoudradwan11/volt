import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/orders/controllers/orders_cubit.dart';
import 'package:volt/features/favorites/controllers/favorite_cubit.dart';
import 'package:volt/features/favorites/controllers/favorite_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/features/orders/models/order_model.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/core/themes/app_colors.dart';

class BuildProductItem extends StatelessWidget {
  const BuildProductItem({super.key, required this.productModel});
  final Product productModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.productDetails,arguments: productModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        height: 200,
        width: 160,
        child: Column(
          children: [
             Expanded(
               child: Row(
                 children: [
                   Expanded(
                     child: Container(
                         decoration: BoxDecoration(
                             color:  AppColors.p2Color,
                             borderRadius: const BorderRadius.only(
                                 topLeft: Radius.circular(20))),
                         child: Center(
                           child: RotatedBox(
                               quarterTurns: 1,
                               child: Text(
                                 productModel.status ?? '',
                                 style:const TextStyle(color: Color(0xFFC8DE22)),
                               )),
                         ),
                     ),
                   ),
                   Expanded(
                     flex: 6,
                     child: Stack(
                       alignment: AlignmentDirectional.topEnd,
                       children: [
                         Container(
                           width: double.infinity,
                           decoration: BoxDecoration(
                             borderRadius: const BorderRadius.only(
                                 topRight: Radius.circular(20)),
                             color: AppColors.p2Color
                           ),
                           height: 125,
                           child: Padding(
                             padding:const EdgeInsets.only(right: 30, left: 10),
                             child: CachedNetworkImage(
                                 imageUrl: productModel.image ?? '',
                                 imageBuilder: (context,imageProvider)=>Image(image: imageProvider),
                                 placeholder:(context,url)=>const Center(child: CircularProgressIndicator(color: Colors.black,),),
                                 errorWidget: (context,url,error){
                                   print(error.toString());
                                   return Center(child: CircularProgressIndicator(color: AppColors.p3Color,),);
                                 }
                             ),
                           ),
                         ),
                         Builder(
                           builder: (context) {
                             FavoriteCubit? favoriteCubit;
                             try {
                               favoriteCubit = FavoriteCubit.get(context);
                             } catch (_) {
                               favoriteCubit = null;
                             }
                             if (favoriteCubit == null) {
                               // No FavoriteCubit in the tree (e.g. a
                               // partial merge): static heart, no toggle.
                               return _favoriteHeart(
                                   productModel.inFavorite ?? false, null);
                             }
                             return BlocBuilder<FavoriteCubit, FavoriteStates>(
                               builder: (context, state) => _favoriteHeart(
                                 favoriteCubit!.isFavorite(productModel),
                                 () => favoriteCubit!
                                     .toggleFavorite(productModel),
                               ),
                             );
                           },
                         )                     ],
                     ),
                   )
                 ],
               ),
             ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:  AppColors.p2Color,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                productModel.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.only(left: 10.0),
                        child: Text(
                          productModel.company ?? '',
                          style:const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Padding(
                            padding:const EdgeInsets.only(left: 10.0),
                            child: Text(
                             '\$${productModel.price}',
                              style:const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          const Spacer(),
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color:Colors.lime,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: MaterialButton(
                                onPressed: () {
                                  // Places a local order for this product
                                  // (saved per customer in sqflite) and it
                                  // shows up right away in the Orders tab.
                                  final price =
                                      (productModel.price as num?)
                                              ?.toDouble() ??
                                          0;
                                  OrdersCubit.get(context).addOrder(
                                    Order(
                                      sId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
                                      createdAt: DateTime.now()
                                          .toUtc()
                                          .toIso8601String(),
                                      status: 'Processing',
                                      paymentMethod: 'Cash on delivery',
                                      totalPaid: price,
                                      items: [
                                        OrderItem(
                                          productId: productModel.sId,
                                          name: productModel.name,
                                          company: productModel.company,
                                          image: productModel.image,
                                          price: price,
                                          quantity: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                  showToast(
                                      'Order placed', ToastStates.SUCCESS);
                                },
                                child: Text(
                                  'Buy'.toUpperCase(),
                                  style:  TextStyle(color:HexColor('184e77')),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// The heart icon on the card: red when the product is in favorites,
  /// grey when not. [onTap] is null when no FavoriteCubit is available.
  Widget _favoriteHeart(bool isFavorite, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundColor: AppColors.p2Color,
          radius: 10,
          child: Icon(
            Icons.favorite,
            size: 15,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
