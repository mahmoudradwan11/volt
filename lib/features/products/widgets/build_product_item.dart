import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/products/models/product_model.dart';

class BuildProductItem extends StatelessWidget {
  BuildProductItem({super.key, required this.productModel});
  Product productModel;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                           color: HexColor('1c435b'),
                           borderRadius: const BorderRadius.only(
                               topLeft: Radius.circular(20))),
                       child: Center(
                         child: RotatedBox(
                             quarterTurns: 1,
                             child: Text(
                               productModel.status!,
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
                           color: HexColor('f5ebdd')
                         ),
                         height: 125,
                         child: Padding(
                           padding:const EdgeInsets.only(right: 30, left: 10),
                           child: CachedNetworkImage(
                               imageUrl:productModel.image!,
                               imageBuilder: (context,imageProvider)=>Image(image: imageProvider),
                               placeholder:(context,url)=>const Center(child: CircularProgressIndicator(color: Colors.black,),),
                               errorWidget: (context,url,error){
                                 print(error.toString());
                                 return Center(child: CircularProgressIndicator(color: HexColor('#07094D'),),);
                               }
                           ),
                         ),
                       ),
                       InkWell(
                         onTap: (){
                         //  productModel.inFavorite?FavoriteCubit.get(context).deleteFavorite(product.sId,context):FavoriteCubit.get(context).addToMyFavorite(product.sId,context);
                         },
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: CircleAvatar(
                             backgroundColor: HexColor('#BFC0E4'),
                             radius: 10,
                             child:Icon(
                                 Icons.favorite,
                                 size: 15,
                                 color:productModel.inFavorite!?Colors.red:Colors.grey
                             ),
                           ),
                         ),
                       )                     ],
                   ),
                 )
               ],
             ),
           ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('1c435b'),
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
                              productModel.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          if(productModel.status=='New')
                            Expanded(
                              child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: HexColor('#C70000'),
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                          left: Radius.circular(20))),
                                  child: const Center(
                                      child: Text(
                                        '10% Off',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ))),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:const EdgeInsets.only(left: 10.0),
                      child: Text(
                        productModel.company!,
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
                                showToast('Added', ToastStates.SUCCESS);
                                // ElWekalaCubit.get(context).addSales(product.sId);
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
    );
  }
}
