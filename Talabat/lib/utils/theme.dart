
import 'package:flutter/material.dart';
import 'package:talabat/utils/constants.dart';

ThemeData theme= ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          primaryColor: primarycolor,
          focusColor: purple,
          primaryColorLight: smallTextColor,
          textTheme: TextTheme(
          bodyLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: purple),
          bodyMedium: TextStyle(fontSize: 18, color: primarycolor , fontWeight: FontWeight.normal),
          bodySmall: const TextStyle(fontSize: 16 ,color:Color.fromARGB(255, 255, 242, 242) ),
          titleMedium: const TextStyle(fontSize: 18, color: black ,  fontWeight: FontWeight.normal ),
          titleLarge: const TextStyle(fontSize: 16 , color: black ,  fontWeight: FontWeight.normal),
          labelLarge: const TextStyle(fontSize: 16, color: black ,  fontWeight: FontWeight.bold), 
          labelMedium: const TextStyle(fontSize: 20, color: black ,  fontWeight: FontWeight.normal)//
          
    ),
);