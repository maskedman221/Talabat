
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/cartcubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/services/service.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/widgets/netImage.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  bool isFavorite = false;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final languageCubit = GetIt.instance<LanguageCubit>();
    final cartCubit=getIt<CartCubit>();
    return Scaffold(
      backgroundColor: primarycolor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // AppBar with SliverAppBar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  background: Netimage(
                    
                  imageUrl:   product.image,
                    width: double.infinity,
                    height: 250,
                    
                  ),
                ),
              ),
              // The main content
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                    
                          SizedBox(height: 8),
                          Text(
                            '\$${product.price}',
                            style: TextStyle(
                                color: black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Description:',
                            style: TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 350, 
                            width: 500,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 223, 223),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  product.description,
                                  style: theme.textTheme.labelMedium,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60, // Adjust the height as needed
              color: Colors.white, // Set the background color
              child: MaterialButton(
                onPressed: (){
                  cartCubit.addProduct(product);
                  
                },
                child: Text(languageCubit.state.lang!['cart']['add']),
                )
            ),
          ),
        ],
      ),
    );
  }
}
