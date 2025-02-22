import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/productcubit.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/widgets/productcard.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('All products'),
      ),
      body: SizedBox(
        child: ListView(
          children: [
            BlocProvider(
              create: (_) => GetIt.I<ProductCubit>()..fetchProducts(),
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  final cubit = context.read<ProductCubit>();

                  if (state.products.isEmpty && state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          !state.isLoading) {
                        cubit.fetchProducts();
                      }
                      return true;
                    },
                    child: Wrap(
                      alignment: WrapAlignment
                          .spaceEvenly, // Adjust alignment as per your needs
                      spacing: 8.0, // Spacing between items
                      runSpacing: 8.0, // Spacing between rows
                      children: List.generate(
                          state.products.length + (state.hasMore ? 1 : 0),
                          (index) {
                        if (index == state.products.length) {
                          return Center(
                            child:
                                CircularProgressIndicator(), // Show loading indicator if there's more to load
                          );
                        }

                        final product =
                            state.products[index]; // Get the product
                        return ProductCard(
                            product: product,
                            index: index); // Return your ProductCard widget
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
