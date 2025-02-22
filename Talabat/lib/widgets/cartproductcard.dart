import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:talabat/core/cubit/cartcubit.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/productcubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/service.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/netImage.dart';

class Cartproductcard extends StatelessWidget {
  Cartproductcard({super.key});

//   @override
//   State<Cartproductcard> createState() => _Cartproductcard();

// }
// class _Cartproductcard extends State<Cartproductcard>{

  // late List<double> _allPrices=[];

  @override
  Widget build(BuildContext context) {
    final cartCubit = getIt<CartCubit>();
    final languageCubit = GetIt.instance<LanguageCubit>();

    if (!cartCubit.state.isLoaded) {
      print("loading");
      cartCubit.loadCartProducts(0);
    }
    return Stack(
      children: [
        BlocBuilder<CartCubit, CartState>(
          bloc: cartCubit,
          builder: (context, state) {
      
            if (state.isLoading)
              return const Center(child: CircularProgressIndicator());
            else if (state.error != null)
              return Center(
                child: Text('Error : ${state.error}'),
              );
            else if (!state.hasProducts)
              return Center(
                child: Text(languageCubit.state.lang!['cart']['noProducts']),
              );
            else {
              print(state.products.length);
              return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.extentAfter == 0 &&
                  !state.isLoading &&
                  state.hasMore) {
                cartCubit.loadCartProducts(state.currentPage);
              }
              return false;
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.products.length + 1,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    itemBuilder: (context, index) {
                      if (index == state.products.length) {
                        if (state.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (!state.hasMore) {
                          return const Center(
                            
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      return CartCard(index: index, state: state);
                    },
                  ),
                ),
              ],
            ),
          );
            }
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context)
              .padding
              .bottom, // Adjust for navigation bar height
          child: BlocBuilder<CartCubit, CartState>(
            bloc: cartCubit,
            builder: (context, state) {
              if (state.hasProducts) {
                return Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primarycolor,
                    // borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          cartCubit.confirmOrder(context);
                        },
                        child: Text(
                          languageCubit.state.lang!['cart']['checkout'],
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      Text(
                        languageCubit.state.lang!['cart']['allPrice'],
                        style: theme.textTheme.labelLarge,
                      ),
                      Text(
                        "${state.finalprice}",
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                );
              } else
                return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
    //
  }
}

class CartCard extends StatelessWidget {
  final int index;

  final languageCubit = GetIt.instance<LanguageCubit>();
  final CartState state;
  final cartCubit = getIt<CartCubit>();
  CartCard({super.key, required this.index, required this.state});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        child: Center(
          child: ListTile(
              leading: SizedBox(
                height: 100,
                width: 75,
                child: Netimage(
                  imageUrl: state.products[index].image,
                  width: 75,
                  height: 100,
                ),
              ),
              title: Text(
                state.products[index].name,
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: IconButton(
                  onPressed: () {
                    cartCubit.removeProduct(state.products[index],
                        state.currentvalue[index], state.allPrice[index]);
                  },
                  icon: const Icon(Icons.cancel)),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        languageCubit.state.lang!['cart']['quantity'],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: ItemCount(
                          initialValue: state.currentvalue[index],
                          minValue: 0,
                          maxValue: 500,
                          decimalPlaces: 0,
                          step: 1,
                          buttonSizeWidth: 40,
                          buttonSizeHeight: 40,
                          onChanged: (value) {
                            cartCubit.productCount(
                                value, index); // Pass the new value and index
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(languageCubit.state.lang!['cart']['price']),
                      const SizedBox(
                        width: 65,
                      ),
                      Text(state.allPrice[index].toString()),
                    ],
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
      ),
    );
  }
}
// FutureBuilder(future: ApiService().getCartProducts(), builder: (context,snapshot){
//         if(snapshot.hasData){
//                if (_currentValues.isEmpty) {
//           _currentValues = List.generate(snapshot.data!.length,
//             (index) => 1);
//           _allPrices = List.generate(snapshot.data!.length,
//             (index) => snapshot.data![index].price);
//         }
//           return Column(

//             children: [
//               Expanded(
//                 child: ListView.separated(itemBuilder: (context,index)=>Card(
//                   clipBehavior: Clip.antiAlias,
//                    shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                   ),

//                       child: ClipRRect(
//                         child: Center(
//                           child: ListTile(
//                           leading: SizedBox(height: 100,width: 75,
//                             child: Image.network(snapshot.data![index].image,width: 75,height:100 ,fit: BoxFit.cover ,errorBuilder:(BuildContext context, Object error, StackTrace? stackTrace){
//                                 return const Icon(
//                                 Icons.error,
//                                 color: Colors.red,
//                                 size: 50,
//                               );
//                             } ,),
//                           ),
//                           title: Text(snapshot.data![index].name, style:theme.textTheme.titleMedium ,overflow: TextOverflow.ellipsis,
//                           maxLines: 1,),
//                           trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.cancel)),
//                           subtitle: Column(
//                             children: [
//                               Row(
//                                 children: [

//                                   Text(lang!['cart']['quantity'],),
//                                   const SizedBox(width: 30,),
//                                   ItemCount(
//                                     initialValue: _currentValues[index],
//                                     minValue: 0,
//                                     maxValue: 10,
//                                     decimalPlaces: 0,
//                                     step: 1,
//                                     buttonSizeWidth: 40,
//                                     buttonSizeHeight: 40,
//                                     onChanged: (value) {

//                                       setState((){
//                                         _currentValues[index]=value;
//                                         _allPrices[index]=snapshot.data![index].price*_currentValues[index];
//                                       });
//                                     },
//                                   ),
//                               ],

//                               ),

//                               Row(
//                                 children: [
//                                   Text(lang!['cart']['price']),
//                                    const SizedBox(width: 65,),

//                                   Text(_allPrices[index].toString()),
//                                 ],
//                               ),
//                             ],
//                           ),

//                             shape: RoundedRectangleBorder(
//                                                borderRadius: BorderRadius.circular(10),

//                                               )

//                                                 ),
//                         ),
//                       ),
//                 ),
//                  separatorBuilder: (context,index)=>const Divider(),
//                  itemCount: snapshot.data!.length,
//                 ),
//               ),
//               // SnackBar(
//               //   content: Row(
//               //     children: [
//               //       MaterialButton(onPressed:(){} , child: Container(width: 150 ,height: 75,child: Text(''), decoration: BoxDecoration(border: Border.all(), ), ) ,),
//               //       Text(''),
//               //       Text(''),
//               //     ],
//               //   ),

//               // ),
//             ],
//           );

//         }
//         else {
//         print(snapshot.data);
//         return const Center(child:CircularProgressIndicator() ,

//         );
//         }
//   },
//  );
