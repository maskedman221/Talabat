import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/models/section.dart';
import 'package:talabat/services/service.dart';

class SectionState {
  final List<Section> sections;
  final bool isLoading;
  final int currentPage;
  final bool hasMore;

  SectionState({
    required this.sections,
    required this.isLoading,
    required this.currentPage,
    required this.hasMore,
  });

  factory SectionState.initial() => SectionState(
        sections: [],
        isLoading: false,
        currentPage: 1,
        hasMore: true,
      );

  SectionState copyWith({
    List<Section>? sections,
    bool? isLoading,
    int? currentPage,
    bool? hasMore,
  }) {
    return SectionState(
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SectionCubit extends Cubit<SectionState> {
  final cubit=getIt<ApiService>();

  SectionCubit() : super(SectionState.initial());

  Future<void> fetchSections() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final productsResponse =
               await cubit.fetchSections(page: state.currentPage);

      emit(
        state.copyWith(
          sections: [...state.sections, ...productsResponse.data],
          currentPage: state.currentPage + 1,
          hasMore: productsResponse.nextPageUrl != null,
        ),
      );
    } catch (e) {
      print('Error fetching sections: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
