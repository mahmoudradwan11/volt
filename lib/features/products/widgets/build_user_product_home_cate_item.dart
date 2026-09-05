import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/models/user_home_cate_model.dart';

Widget buildCateItem(UserHomeCateModel categoryModel,index,context)=>Padding(
  padding: const EdgeInsets.all(8.0),
  child:   InkWell(
    onTap:(){
      UserHomeCubit.get(context).changeCategoryIndex(index);
      if(index==0) {
        ProductCubit.get(context).getProducts('Laptops');
      }else if(index == 1){
        ProductCubit.get(context).getProducts('Smart Phones');
      }else if(index == 2){
        ProductCubit.get(context).getProducts('Smart Watches');
      }else if(index == 3){
        ProductCubit.get(context).getProducts('Smart TVs');
      }else if(index == 4){
        ProductCubit.get(context).getProducts('PC and laptop accessories');
      }
    },
    child: Container(
      decoration: BoxDecoration(
          gradient:UserHomeCubit.get(context).chooseCategoryColor(index),
          borderRadius: BorderRadius.circular(12)
      ),
      width:200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
                color:UserHomeCubit.get(context).currentCategoryIndex==index?HexColor('#6365A4'):Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image(image:AssetImage(categoryModel.image),height: 50,width: 50,fit: BoxFit.contain,),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(categoryModel.title,style: TextStyle(color:UserHomeCubit.get(context).currentCategoryIndex==index?Colors.white:Colors.black,fontSize: 15)),
                    const SizedBox(
                      height: 1,
                    ),
                    Text('100 product',style: TextStyle(color:UserHomeCubit.get(context).currentCategoryIndex==index?HexColor('#898BDB'):HexColor('#5C5C5D'),),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ),
);