import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/models/section.dart';
import 'package:talabat/models/store.dart';
import 'package:talabat/services/service.dart';

class StoreState {
  final List<Store> stores;
  final bool isLoading;
  final int currentPage;
  final bool hasMore;

  StoreState({
    required this.stores,
    required this.isLoading,
    required this.currentPage,
    required this.hasMore,
  });

  factory StoreState.initial() => StoreState(
        stores: [],
        isLoading: false,
        currentPage: 1,
        hasMore: true,
      );

  StoreState copyWith({
    List<Store>? stores,
    bool? isLoading,
    int? currentPage,
    bool? hasMore,
  }) {
    return StoreState(
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class StoreCubit extends Cubit<StoreState> {
  final cubit=getIt<ApiService>();

  StoreCubit() : super(StoreState.initial());

  Future<void> fetchStores() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final storesResponse =
               await cubit.fetchStores(page: state.currentPage);

      emit(
        state.copyWith(
          stores: [...state.stores, ...storesResponse.data],
          currentPage: state.currentPage + 1,
          hasMore: storesResponse.nextPageUrl != null,
        ),
      );
    } catch (e) {
      print('Error fetching stores: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
