import 'package:flutter/material.dart';  
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/languagecubit.dart';  
import 'package:talabat/core/cubit/searchcubit.dart';  
import 'package:talabat/widgets/productcard.dart';  
import 'package:talabat/core/serviceLocater.dart';  
import 'package:talabat/services/service.dart';  
import 'package:talabat/models/product.dart';  

final ApiService apiService = ApiService();  

class FilterbyStore extends StatefulWidget {  
  final int store_id;  
  const FilterbyStore({super.key, required this.store_id});  

  @override  
  State<StatefulWidget> createState() => _FilterbyStoreState();  
}  

class _FilterbyStoreState extends State<FilterbyStore> {  
  final SearchCubit searchCubit = getIt<SearchCubit>();  
  final languageCubit=getIt<LanguageCubit>();
  List<Product> products = [];  
  int currentPage = 1; // Track the current page  
  bool isLoading = false; // Track loading state  
  bool hasMore = true; // Track if there are more products to load  

  @override  
  void initState() {  
    super.initState();  
    _filterProducts(); // Fetch products when the page is opened  
  }  

  void _filterProducts({int page = 1}) async {  
    if (isLoading || !hasMore) {  
      return; // Prevent multiple requests if already loading or no more products  
    }  

    setState(() {  
      isLoading = true; // Set loading state  
    });  
// locale:languageCubit.state.isEnglish? 'en' : 'ar'
    try {  
      List<Product> newProducts =  
          await apiService.getProducts(page: page, storeId: widget.store_id,);  
      print(newProducts);  

      if (newProducts.isNotEmpty) {  
        setState(() {  
          products.addAll(newProducts); // Add new products to the list  
          currentPage = page; // Update current page  
          hasMore = newProducts.length == 10; // Assuming API returns 10 products per page  
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
        title: Text(languageCubit.state.lang!["headLines"]["ProductsPage"]), // Updated title for clarity  
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
                          _filterProducts(page: currentPage + 1); // Load next page  
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