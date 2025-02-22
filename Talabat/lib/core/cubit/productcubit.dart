import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/services/service.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final int currentPage;
  final bool hasMore;

  ProductState({
    required this.products,
    required this.isLoading,
    required this.currentPage,
    required this.hasMore,
  });

  factory ProductState.initial() => ProductState(
        products: [],
        isLoading: false,
        currentPage: 1,
        hasMore: true,
      );

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    int? currentPage,
    bool? hasMore,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ProductCubit extends Cubit<ProductState> {
  final cubit=getIt<ApiService>();

  ProductCubit() : super(ProductState.initial());

  Future<void> fetchProducts() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final productsResponse =
               await cubit.fetchProducts(page: state.currentPage);

      emit(
        state.copyWith(
          products: [...state.products, ...productsResponse.data],
          currentPage: state.currentPage + 1,
          hasMore: productsResponse.nextPageUrl != null,
        ),
      );
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

    Future<void> fetchCartProducts() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true,currentPage:1));

    try {
      final productsResponse =
               await cubit.fetchCartProducts(page: state.currentPage);

      emit(
        state.copyWith(
          products: [...state.products, ...productsResponse.data],
          currentPage: state.currentPage + 1,
          hasMore: productsResponse.nextPageUrl != null,
        ),
      );
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
