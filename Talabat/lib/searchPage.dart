import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/searchcubit.dart';
import 'package:talabat/widgets/productcard.dart';
import 'package:talabat/core/serviceLocater.dart';

import 'package:talabat/services/service.dart';
import 'package:talabat/models/product.dart';

final ApiService apiService = ApiService();

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchCubit searchCubit = getIt<SearchCubit>();

  List<Product> products = [];
  int currentPage = 1; // Track the current page
  bool isLoading = false; // Track loading state
  bool hasMore = true; // Track if there are more products to load

  void _searchProducts(String query, {int page = 1}) async {
    if (isLoading || !hasMore) {
      return; // Prevent multiple requests if already loading or no more products
    }

    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      List<Product> newProducts =
          await apiService.getProducts(query: query, page: page);
      print(newProducts);

      if (newProducts.isNotEmpty) {
        setState(() {
          products.addAll(newProducts); // Add new products to the list
          currentPage = page; // Update current page
          hasMore = newProducts.length ==
              10; // Assuming API returns 10 products per page
        });
      } else {
        hasMore = false; // No more products available
      }

      searchCubit.searchResults(products);
    } catch (e) {
      print("Error fetching products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error')),
      );
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        forceMaterialTransparency: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            onChanged: (value) {
              products.clear(); // Clear previous search results

              currentPage = 1; // Reset current page
              hasMore = true; // Reset hasMore flag
              _searchProducts(value); // Start new search
            },
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              alignLabelWithHint: true,
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  products.clear(); // Clear previous search results
                  currentPage = 1; // Reset current page
                  hasMore = true; // Reset hasMore flag
                  _searchProducts(_searchController.text); // Start new search
                },
              ),
            ),
            onFieldSubmitted: (value) {
              products.clear(); // Clear previous search results
              currentPage = 1; // Reset current page
              hasMore = true; // Reset hasMore flag
              _searchProducts(value); // Start new search
            },
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, searchState>(
        bloc: searchCubit,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 10,
                    spacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...List.generate(
                        products.length,
                        (index) => ProductCard(
                          product: products[index],
                          index: index,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasMore) // Show load more button if more products are available
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _searchProducts(_searchController.text,
                              page: currentPage + 1); // Load next page
                        },
                        child: isLoading
                            ? CircularProgressIndicator() // Show loading indicator
                            : Text("Load More"),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
