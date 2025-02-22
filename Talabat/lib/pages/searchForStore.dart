import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/oneStoreCubit.dart';
import 'package:talabat/models/oneStore.dart';
import 'package:talabat/widgets/oneStoreCard.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/service.dart';

final ApiService apiService = ApiService();

class SearchForStorePage extends StatefulWidget {
  const SearchForStorePage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchForStorePageState();
}

class _SearchForStorePageState extends State<SearchForStorePage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchStoreCubit searchStoreCubit = getIt<SearchStoreCubit>();

  List<Onestore> Stores = [];
  int currentPage = 1; // Track the current page
  bool isLoading = false; // Track loading state
  bool hasMore = true; // Track if there are more Stores to load

  void _searchStores(String query, {int page = 1}) async {
    if (isLoading || !hasMore) {
      return; // Prevent multiple requests if already loading or no more Stores
    }

    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      List<Onestore> newStores =
          await apiService.getStores(query: query, page: page);
      print(newStores);

      if (newStores.isNotEmpty) {
        setState(() {
          Stores.addAll(newStores); // Add new Stores to the list
          currentPage = page; // Update current page
          hasMore =
              newStores.length == 10; // Assuming API returns 10 Stores per page
        });
      } else {
        hasMore = false; // No more Stores available
      }

      searchStoreCubit.searchResults(Stores);
    } catch (e) {
      print("Error fetching Stores: $e");
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
            onChanged: (value) {
              Stores.clear(); // Clear previous search results

              currentPage = 1; // Reset current page
              hasMore = true; // Reset hasMore flag
              _searchStores(value); // Start new search
            },
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Stores.clear(); // Clear previous search results
                  currentPage = 1; // Reset current page
                  hasMore = true; // Reset hasMore flag
                  _searchStores(_searchController.text); // Start new search
                },
              ),
            ),
            onFieldSubmitted: (value) {
              Stores.clear(); // Clear previous search results
              currentPage = 1; // Reset current page
              hasMore = true; // Reset hasMore flag
              _searchStores(value); // Start new search
            },
          ),
        ),
      ),
      body: BlocBuilder<SearchStoreCubit, searchStoreState>(
        bloc: searchStoreCubit,
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
                        Stores.length,
                        (index) => OneStoreCard(
                          store: Stores[index],
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasMore) // Show load more button if more Stores are available
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _searchStores(_searchController.text,
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
