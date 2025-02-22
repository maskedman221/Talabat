import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/screens/productdetails.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/netImage.dart';
import 'package:talabat/widgets/netImage.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final homeCubit = getIt<HomeCubit>();
  final int index;

  ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  State<ProductCard> createState() =>
      _ProductCard(product: product, index: index);
}

class _ProductCard extends State<ProductCard> {
  final Product product;
  final homeCubit = getIt<HomeCubit>();

  final int index;

  _ProductCard({
    required this.product,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        builder: (context, state) {
          print(product.id);
          bool isFavorite = homeCubit.isProductFavorite(product);
          print(isFavorite);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: product)));
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: primarycolor,
                border: Border(
                  top: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.deepPurple),
                  right: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.deepPurple),
                  left: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.deepPurple),
                  bottom: BorderSide(
                      width: 4,
                      style: BorderStyle.solid,
                      color: Colors.deepPurple),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 160,
                // height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Netimage(
                        imageUrl: "${product.image}",
                        height: 150,
                        width: 160,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 40),
                        Text(
                            "\$${product.price.toStringAsFixed(2)}", // Two decimal places
                            style: theme.textTheme.bodySmall),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            homeCubit.addFav(product, isFavorite, product.name);
                          },
                        ),
                      ],
                    ),
                    Text(
                      product.name,
                      style: theme.textTheme.bodySmall,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
