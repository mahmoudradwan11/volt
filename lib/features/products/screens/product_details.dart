import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/features/products/controllers/product_cubit.dart';
import 'package:volt/features/products/controllers/product_states.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>
      (listener:(context,state){},
    builder: (context,state){
      return Scaffold();

    },);
  }
}
