import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/ordercubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/order.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/ordercard.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderCubit = getIt<OrderCubit>();
    final languageCubit = getIt<LanguageCubit>();
 
    if (!orderCubit.state.isLoaded) {
      print("calling loadOrders");
      orderCubit.loadOrders();
    }

    return Column(
      children: [
        AppBar(
          title: Text(
            languageCubit.state.lang!['headLines']['OrdersPage'],
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor),
          ),
        ),
        SingleChildScrollView(
          child: BlocBuilder<OrderCubit, OrderState>(
            bloc: orderCubit,
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error.isNotEmpty) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state.orders.isEmpty) {
                return Center(child: Text('No orders available'));
              } else {
                return ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    // Toggle the isExpanded value
                    final updatedOrders = List<Order>.from(state.orders);
                    updatedOrders[index] = updatedOrders[index].copyWith(
                      isExpanded: !updatedOrders[index].isExpanded,
                    );
                    orderCubit.updateOrders(updatedOrders); // Emit new state
                  },
                  children:
                      state.orders.asMap().entries.map<ExpansionPanel>((entry) {
                    final int i = entry.key; // The index of the current order
                    final Order order = entry.value; // The current order object
                    //  String formattedDate = DateFormat('yyyy-MM-dd').format(order.date);
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            '${languageCubit.state.lang!["order"]["total"]}: ${order.totalprice}',
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: SizedBox(
                            width: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(' ${order.status}'),
                                Text(order.date),
                              ],
                            ),
                          ),
                          leading: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          trailing: SizedBox(
                            width: 50,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (order.status == 'pending') {
                                        showCustomDialog(
                                          context: context,
                                          title: languageCubit.state.lang!["Process"]["confirmprocess"],
                                          content:
                                              languageCubit.state.lang!["order"]["cancel"],
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text(languageCubit.state.lang!["Process"]["cancel"]),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async{
                                               await orderCubit.removeOrder(order);
                                                // Perform the action and close the dialog
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          languageCubit.state.lang!["Process"]["confirmd"])),
                                                );
                                              },
                                              child: Text(languageCubit.state.lang!["Process"]["confirm"]),
                                            ),
                                          ],
                                        );
                                        
                                      }
                                    },
                                    icon: Icon(order.status == 'pending'
                                        ? Icons.cancel
                                        : Icons.circle)),
                              ],
                            ),
                          ),
                        );
                      },
                      body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.products.length,
                        itemBuilder: (context, index) {
                          // final product = order.products[index];
                          return OrderCard(
                              orderindex: i, state: state, index: index);
                        },
                      ),
                      isExpanded: order.isExpanded,
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
