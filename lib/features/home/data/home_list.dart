import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:volt/features/products/screens/Product.dart';
import 'package:volt/users/Screens/cateogry.dart';
import 'package:volt/users/Screens/orders.dart';
import 'package:volt/users/Screens/profile.dart';
import 'package:volt/users/Screens/wishlist.dart';

List<GButton> tabs =const [
  GButton(icon:Icons.home_rounded,text: 'Home',),
  GButton(icon:Icons.grid_view_rounded,text: 'Category',),
  GButton(icon:Icons.receipt_long_rounded,text:'Orders',),
  GButton(icon:Icons.favorite_border_rounded,text: 'Wishlist',),
  GButton(icon:Icons.person_outline_rounded,text: 'Profile',),
];

List<Widget> screens = [
  ProductScreen(),
  CategoryScreen(),
  OrdersScreens(),
  WishlistScreen(),
  ProfileScreen()
];
