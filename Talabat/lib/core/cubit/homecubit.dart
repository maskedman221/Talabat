import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/models/section.dart';
import 'package:talabat/models/store.dart';
import 'package:talabat/services/service.dart';

class HomeState {
  final int selectedIndex;
  final List<Product> favProducts;
  final List<bool> isFavorite;
  final List<Product> products;
  final List<Section> sections;
  final List<Store> stores;
  final bool isLoading;
  final bool isLoaded;
  final String? error;
  HomeState({
    required this.selectedIndex,
    required this.favProducts,
    required this.isFavorite,
    required this.products,
    required this.sections,
    required this.stores,
    required this.isLoading,
    required this.isLoaded,
    this.error,
  });
  factory HomeState.initial() => HomeState(
        selectedIndex: 0,
        favProducts: [],
        isFavorite: [],
        products: [],
        sections: [],
        stores: [],
        isLoading: false,
        isLoaded: false,
        error: null,
      );
  HomeState copyWith({
    int? selectedIndex,
    List<Product>? favProducts,
    List<bool>? isFavorite,
    List<Product>? products,
    List<Section>? sections,
    List<Store>? stores,
    bool? isLoading,
    bool? isLoaded,
    String? error,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      favProducts: favProducts ?? this.favProducts,
      isFavorite: isFavorite ?? this.isFavorite,
      products: products ?? this.products,
      sections: sections ?? this.sections,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  final cubit = getIt<ApiService>();

  HomeCubit() : super(HomeState.initial());
  
    Future<void> setHome() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await cubit.getHome();

      List<Product> latestProducts = List.generate(
        data["latest_products"].length,
        (index) => Product.fromJsonP(data["latest_products"][index]),
      );
      List<Section> sections = List.generate(
        data["sections"].length,
        (index) => Section.fromMap(data["sections"][index]),
      );
      List<Store> latestStores = List.generate(
        data["latest_stores"].length,
        (index) => Store.fromMapS(data["latest_stores"][index]),
      );

      emit(state.copyWith(
        products: latestProducts,
        sections: sections,
        stores: latestStores,
        isLoading: false,
        
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  setIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  setSize(int length) {
    final List<bool> isFav = List.filled(length, false, growable: true);
    emit(state.copyWith(isFavorite: isFav));
  }

  addFav(Product product, bool isFavorite, String name) async{
    if (!isFavorite) {
      await cubit.postFavorite(product.id);
      final products = List<Product>.from(state.favProducts);
      products.add(product);
      emit(state.copyWith(favProducts: products));
    } else {
      // Remove the product with the same name if it exists
      await cubit.deleteFavorite(product.id);
      final products = List<Product>.from(state.favProducts);
      products.removeWhere((existingProduct) => existingProduct.name == name);
      emit(state.copyWith(favProducts: products));
    }
  }
 Future<void> getFav() async{
  emit(state.copyWith(isLoading: true, error: null));
      try{
        
        final favProducts=await cubit.getFavorite(); 
        
        emit(state.copyWith(favProducts: favProducts, isLoading: false));
        print(favProducts);
      }
      catch (e){
        print("error getting favorite ${e.toString()}");
        emit(state.copyWith(isLoading: false));
      }
  }
  bool isProductFavorite(Product product) {
   return state.favProducts.any((favProduct) => favProduct.id == product.id);
  }

  setFav(bool fav, int index) {
    final isFav = List<bool>.from(state.isFavorite);
    isFav[index] = fav;
    emit(state.copyWith(isFavorite: isFav));
  }
}
