import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/cartcubit.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/profilecubit.dart';
import 'package:talabat/firebase_options.dart';
import 'package:talabat/homePage.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/authApis.dart';
import 'package:talabat/services/service.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
   await setupLocator();
   try {
  await dotenv.load(fileName: ".env");
} catch (e) {
  print("Error loading .env file: $e");
}
  final translations = await loadTranslations();
  final profileCubit=getIt<ProfileCubit>();
  final languageCubit=getIt<LanguageCubit>();
  
  final cubit=getIt<ApiService>();
     languageCubit.setupLanguage(translations);
  cubit.setHeaders(languageCubit.state.isEnglish? 'en' : 'ar');
  profileCubit.loadProfileData();
  print(profileCubit.state.image );
  print(profileCubit.state.profileImage);
  await Firebase.initializeApp(); 
  Stripe.publishableKey=publishKey;
  print(await AuthApis().getFcmToken());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     final languageCubit = getIt<LanguageCubit>();
     
    return BlocBuilder(
      bloc: languageCubit,
      builder: (context, state)  {
        return MaterialApp(
          
        title: 'talabat',
        theme: theme,
        home:  Homepage(),
      );
      },
    );
  
  }
}
