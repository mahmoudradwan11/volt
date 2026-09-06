import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/features/home/controllers/user_home_cubit.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/models/user_home_cate_model.dart';

Widget buildCateItem(UserHomeCateModel categoryModel,index,context)=>Padding(
  padding: const EdgeInsets.all(8.0),
  child:   InkWell(
    onTap:(){
      UserHomeCubit.get(context).changeCategoryIndex(index);
      ProductCubit.get(context).getProducts(categoryModel.apiCategory);
    },
    child: Container(
      decoration: BoxDecoration(
          color: UserHomeCubit.get(context).chooseCategoryColor(index),
          borderRadius: BorderRadius.circular(12)
      ),
      width:80,
      height:100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image(image:AssetImage(categoryModel.image),height: 40,width: 40,fit: BoxFit.contain,),
                  )),
              Text(categoryModel.title,style: TextStyle(color:AppColors.whiteColor,fontSize: 10),)
            ],
          ),
        ),
      ),
    ),
  ),
);