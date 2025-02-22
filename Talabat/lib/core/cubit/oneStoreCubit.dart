import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/models/oneStore.dart';
import 'package:talabat/services/shared_preferences_service.dart';
import 'package:get_it/get_it.dart';

class searchStoreState {
  final List<Onestore>? stores;

  searchStoreState({this.stores});

  factory searchStoreState.initial() => searchStoreState(
        stores: [],
      );

  searchStoreState copyWith({
    List<Onestore>? stores,
  }) {
    return searchStoreState(
      stores: stores ?? this.stores,
    );
  }
}

class SearchStoreCubit extends Cubit<searchStoreState> {

  SearchStoreCubit() : super(searchStoreState.initial());

  searchResults(List<Onestore> stores) {
    emit(state.copyWith(
      stores: stores,
    ));
  }
}
