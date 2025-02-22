import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/cartcubit.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/oneStoreCubit.dart';
import 'package:talabat/core/cubit/ordercubit.dart';
import 'package:talabat/core/cubit/productcubit.dart';
import 'package:talabat/core/cubit/profilecubit.dart';
import 'package:talabat/core/cubit/sectioncubit.dart';
import 'package:talabat/core/cubit/storecubit.dart';
import 'package:talabat/models/section.dart';
import 'package:talabat/core/cubit/searchcubit.dart';
import 'package:talabat/services/service.dart';
import 'package:talabat/services/shared_preferences_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  await SharedPreferencesService.init(); // Ensure this is fully initialized first
  getIt.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  
  // Register ApiService after SharedPreferences
  getIt.registerSingleton<ApiService>(ApiService());

  // Register cubits
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());
  getIt.registerLazySingleton<OrderCubit>(() => OrderCubit());
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit());
  getIt.registerSingleton<LanguageCubit>(LanguageCubit());
  getIt.registerLazySingleton<SearchCubit>(() => SearchCubit());
  getIt.registerLazySingleton<SearchStoreCubit>(() => SearchStoreCubit());

  // getIt.registerSingleton<SearchCubit>(SearchCubit());
  getIt.registerSingleton<HomeCubit>(HomeCubit());
  getIt.registerFactory<ProductCubit>(() => ProductCubit());
  getIt.registerFactory<SectionCubit>(() => SectionCubit());
  getIt.registerFactory<StoreCubit>(() => StoreCubit());
}
