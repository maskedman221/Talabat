
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/cubit/homecubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';

import '../widgets/productcard.dart';

class FavoriteScreen extends StatelessWidget {
  
 
  @override
  Widget build(BuildContext context) {
        final homeCubit=getIt<HomeCubit>();
        final languageCubit=getIt<LanguageCubit>();
        
        homeCubit.getFav();
        
        return 
          Scaffold(
            appBar: AppBar(
              title: Text(languageCubit.state.lang!["favorite"]),
            ),
            body: BlocBuilder<HomeCubit,HomeState>(
            bloc: homeCubit,
            builder: (context,state){
            if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } 
               else if (state.favProducts.isEmpty) {
                return Center(child: Text('No products is faviorate'));
              } else {
           return Container(
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 250),
              itemCount: state.favProducts.length, 
              itemBuilder: (context,index){
                return ProductCard(product: state.favProducts[index],index:index);
            
              }
             
              
              ),
            );
                  
            }
            }
                    ),
          );


  }
  

}