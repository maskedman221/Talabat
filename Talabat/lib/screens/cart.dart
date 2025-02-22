import 'package:flutter/material.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/widgets/cartproductcard.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCubit = getIt<LanguageCubit>();
    return Column(
      children: [
        AppBar(
          title: Text(
            languageCubit.state.lang!['headLines']['CartPage'],
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor),
          ),
        ),
        Flexible(child: Cartproductcard()),
      ],
    );
  }
}
