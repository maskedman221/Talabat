import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/models/user.dart';
import 'dart:io';
import 'package:talabat/services/shared_preferences_service.dart';
import 'package:get_it/get_it.dart';

class searchState {
  final List<Product>? products ;
  
  searchState({this.products});

  factory searchState.initial() => searchState(
        products: [],
      );

  searchState copyWith({
    List<Product>? products,
    
  }) {
    return searchState(
      products: products ?? this.products,
      
    );
  }
}

class SearchCubit extends Cubit<searchState> {
  final  _prefs = GetIt.I<SharedPreferencesService>();
  
  SearchCubit() : super(searchState.initial());

  searchResults(List<Product> Products) {

    emit(state.copyWith(products: Products,));
  }
}
