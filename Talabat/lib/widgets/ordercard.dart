import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/ordercubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/netImage.dart';

class OrderCard extends StatelessWidget {
  final int orderindex;
  final int index;
  // final Product product;
  // final Order order;
  final OrderState state;
  final orderCubit = getIt<OrderCubit>();
  final languageCubit = GetIt.instance<LanguageCubit>();

  OrderCard(
      {super.key,
      required this.orderindex,
      required this.state,
      required this.index});
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
                  
                  imageUrl: state.orders[orderindex].products[index].image,
                  width: 75,
                  height: 100,
                ),
              ),
              title: Text(
                state.orders[orderindex].products[index].name,
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: BlocBuilder<OrderCubit, OrderState>(
                  bloc: orderCubit,
                  builder: (context, state) {
                    if (state.orders[orderindex].status == "pending") {
                      return IconButton(
                          onPressed: () {
                            // print(orderindex);
                            print(index);
                            print(state.orders[orderindex].allPrice[index]);
                            orderCubit.removeProduct(
                                state.orders[orderindex].id,
                                state.orders[orderindex].products[index],
                                state.orders[orderindex].currentvalue[index],
                                state.orders[orderindex].allPrice[index],
                                orderindex);
                          },
                          icon: const Icon(Icons.cancel));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text(languageCubit.state.lang!['order']['productprice']),
                      const SizedBox(
                        width: 30,
                      ),
                      Text('${state.orders[orderindex].products[index].price}')
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        languageCubit.state.lang!['order']['quantity'],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      BlocBuilder<OrderCubit, OrderState>(
                          bloc: orderCubit,
                          builder: (context, state) {
                            if (state.orders[orderindex].status == "pending") {
                              return Directionality(
                                textDirection: TextDirection.ltr,
                                child: ItemCount(
                                  initialValue: state
                                      .orders[orderindex].currentvalue[index],
                                  minValue: 0,
                                  maxValue: 100,
                                  decimalPlaces: 0,
                                  step: 1,
                                  buttonSizeWidth: 40,
                                  buttonSizeHeight: 40,
                                  onChanged: (value) {
                                    orderCubit.productCount(
                                        value, index, orderindex);
                                  },
                                ),
                              );
                            } else {
                              return Text(
                                  '${state.orders[orderindex].currentvalue[index]}');
                            }
                          }),
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
