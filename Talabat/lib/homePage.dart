// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/store.dart';
import 'package:talabat/screens/cart.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/orders.dart';
import 'package:talabat/utils/constants.dart';

import 'screens/profile.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const OrdersScreen(),
    const CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final languageCubit = getIt<LanguageCubit>(); // Access the LanguageCubit
    final homeCubit = getIt<HomeCubit>(); // Access the HomeCubit

    return Scaffold(
      
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        builder: (context, state) {
          // Directly render the selected widget
          switch (state.selectedIndex) {
            case 0:
              return languageCubit.state.isEnglish?
               Directionality(
                textDirection: TextDirection.ltr,
                child: const HomeScreen()):
                 Directionality(
                textDirection: TextDirection.rtl,
                child: const HomeScreen());
            case 1:
            return languageCubit.state.isEnglish?
               Directionality(
                textDirection: TextDirection.ltr,
                child: const OrdersScreen()):
                 Directionality(
                textDirection: TextDirection.rtl,
                child: const OrdersScreen());
            case 2:
             return languageCubit.state.isEnglish?
               Directionality(
                textDirection: TextDirection.ltr,
                child: const CartScreen()):
                 Directionality(
                textDirection: TextDirection.rtl,
                child: const CartScreen());
            case 3:
                return languageCubit.state.isEnglish?
               Directionality(
                textDirection: TextDirection.ltr,
                child:  ProfileScreen()):
                 Directionality(
                textDirection: TextDirection.rtl,
                child:  ProfileScreen());
            default:
              return const HomeScreen();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        builder: (context, state) {
          // Update BottomNavigationBar labels dynamically
          return BottomNavigationBar(
            selectedItemColor: Theme.of(context).focusColor,
            unselectedItemColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.assignment_rounded),
                label: "Orders",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart_rounded),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label:  "Profile",
              ),
            ],
            currentIndex: state.selectedIndex,
            onTap: homeCubit.setIndex,
          );
        },
      ),
    );
  }
}