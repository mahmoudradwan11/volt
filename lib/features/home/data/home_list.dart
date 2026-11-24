import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:volt/features/orders/screens/orders_screen.dart';
import 'package:volt/features/products/screens/Product.dart';
import 'package:volt/features/category/screens/category_screen.dart';
import 'package:volt/features/profile/screens/settings_screen.dart';
import 'package:volt/features/favorites/screens/favorites_screen.dart';

List<GButton> tabs =const [
  GButton(icon:Icons.home_rounded,text: 'Home',),
  GButton(icon:Icons.grid_view_rounded,text: 'Category',),
  GButton(icon:Icons.receipt_long_rounded,text:'Orders',),
  GButton(icon:Icons.favorite_border_rounded,text: 'Wishlist',),
  GButton(icon:Icons.person_outline_rounded,text: 'Profile',),
];

List<Widget> screens = [
  ProductScreen(),
  const CategoryScreen(),
  const OrdersScreen(),
  const FavoritesScreen(),
  const SettingsScreen()
];
