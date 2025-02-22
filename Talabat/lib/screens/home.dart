// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';

import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/pages/searchForStore.dart';
import 'package:talabat/screens/products.dart';
import 'package:talabat/screens/stores.dart';
import 'package:talabat/searchPage.dart';
import 'package:talabat/widgets/categorycard.dart';
import 'package:talabat/widgets/productcard.dart';
import 'package:talabat/widgets/storecard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final languageCubit = getIt<LanguageCubit>();
    final homeCubit = getIt<HomeCubit>();
  
      
      homeCubit.getFav();
      homeCubit.setHome();
      // print(homeCubit.state.favProducts);
      
    
    return Column(
      children: [
        AppBar(
          forceMaterialTransparency: true,
          actions: [_searchIcon(context)],
          title: Text(
            languageCubit.state.lang!['headLines']['Home'],
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                BlocBuilder<HomeCubit, HomeState>(
                  bloc: homeCubit,
                  builder: (context, state) {
                    if (state.sections.isEmpty && state.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: [
                        Text(
                          languageCubit.state.lang!['headLines']
                              ['SectionsPage'],
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).focusColor),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10, // Horizontal spacing between items
                          runSpacing: 10, // Vertical spacing between items
                          children: [
                            ...state.sections.map((section) {
                              return CategoryCard(section: section);
                            }).toList(),
                          ],
                        ),
                        Text(
                          languageCubit.state.lang!['headLines']['StoresPage'],
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).focusColor),
                        ),
                        SizedBox(
                            child: Wrap(
                          spacing: 10, // Horizontal spacing between items
                          runSpacing: 10, // Vertical spacing between lines
                          children: [
                            for (int index = 0;
                                index < state.stores.length;
                                index++)
                              SizedBox(
                                // Adjust width to fit 2 items per row
                                child: StoreCard(
                                  store: state.stores[index],
                                ),
                              ),
                          ],
                        )),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchForStorePage()));
                          },
                          child: Text(languageCubit.state.lang!['ShowAll']),
                        ),
                        Text(
                          languageCubit.state.lang!['headLines']
                              ['ProductsPage'],
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).focusColor),
                        ),
                        Wrap(
                            alignment: WrapAlignment.spaceAround,
                            spacing: 10, // Horizontal spacing between items
                            runSpacing: 10, // Vertical spacing between lines
                            children:
                                List.generate(state.products.length, (index) {
                              return SizedBox(
                                child: ProductCard(
                                  product: state.products[index],
                                  index:
                                      index, // Pass the index to the ProductCard
                                ),
                              );
                            })),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchPage()));
                          },
                          child: Text(languageCubit.state.lang!['ShowAll']),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SearchPage()));
        },
      ),
    );
  }
}
