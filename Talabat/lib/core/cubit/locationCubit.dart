import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/service.dart';

class LocationState {
  final double longitude;
  final double latitude;

  

  factory LocationState.initial() => LocationState(
        longitude : 0,
        latitude : 0 
      );

  LocationState({required this.longitude, required this.latitude});
}

class LocationCubit extends Cubit<LocationState> {
  final cubit = getIt<ApiService>();

  LocationCubit() : super(LocationState.initial());
  
}
