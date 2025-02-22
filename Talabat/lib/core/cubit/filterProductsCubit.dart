import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/services/shared_preferences_service.dart';
import 'package:get_it/get_it.dart';

class filterProducts {
  final List<Product>? products ;
  
  filterProducts({this.products});

  factory filterProducts.initial() => filterProducts(
        products: [],
      );

  filterProducts copyWith({
    List<Product>? products,
    
  }) {
    return filterProducts(
      products: products ?? this.products,
      
    );
  }
}

class FilterProductsCubit extends Cubit<filterProducts> {
  final  _prefs = GetIt.I<SharedPreferencesService>();
  
  FilterProductsCubit() : super(filterProducts.initial());

  searchResults(List<Product> Products) {

    emit(state.copyWith(products: Products,));
  }
  
}
