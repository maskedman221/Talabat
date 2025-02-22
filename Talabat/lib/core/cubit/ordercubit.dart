import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/order.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/services/service.dart';

class OrderState {
  final List<Order> orders;
  final String error;
  final bool isLoading;
  final bool isLoaded;
  final bool hasOrders;
  final List<bool> isExpanded;

  OrderState({
    required this.orders,
    required this.isLoading,
    required this.isLoaded,
    required this.error,
    required this.isExpanded,
    required this.hasOrders,
  });
  factory OrderState.initial() => OrderState(
        orders: [],
        isExpanded: [],
        isLoading: false,
        isLoaded: false,
        hasOrders: false,
        error: "",
      );
  OrderState copyWith({
    List<Order>? orders,
    List<bool>? isExpanded,
    bool? isLoading,
    bool? isLoaded,
    bool? hasOrders,
    String? error,
  }) {
    return OrderState(
        orders: orders ?? this.orders,
        isExpanded: isExpanded ?? this.isExpanded,
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        hasOrders: hasOrders ?? this.hasOrders,
        error: error ?? this.error);
  }
}

class OrderCubit extends Cubit<OrderState> {
  final cubit = getIt<ApiService>();

  OrderCubit() : super(OrderState.initial());

  Future<void> loadOrders() async {
    if (state.isLoaded) return;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final orders = await cubit.getOrders();
      emit(state.copyWith(orders: orders, isLoading: false));
      print('loading inside');
      List<Order> updatedOrders = [];
      for (int i = 0; i < orders.length; i++) {
        List<num> currentvalue = List<num>.filled(
            orders[i].products.length, 0); // Fill with 0 initially
        List<double> allPrice =
            List<double>.filled(orders[i].products.length, 0.0);
        double totalprice = 0.0;
        for (int j = 0; j < orders[i].products.length; j++) {
          currentvalue[j] = orders[i].products[j].quantity;
          allPrice[j] =
              currentvalue[j].toInt() * orders[i].products[j].price.toDouble();
          totalprice += allPrice[j];
        }
        updatedOrders.add(
          orders[i].copyWith(
            currentvalue: currentvalue,
            allPrice: allPrice,
            totalprice: totalprice,
          ),
        );
      }
      emit(state.copyWith(orders: updatedOrders, isLoading: false, error: ""));
      print('done');
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      print(e.toString());
    }
  }

  updateOrders(List<Order> updatedOrders) {
    emit(state.copyWith(orders: updatedOrders));
  }

  void removeProduct(
      int orderId, Product product, num count, double price, int index) async {
    await cubit.deleteProductOrder(orderId, product.id);
    final updatedProducts = List<Product>.from(state.orders[index].products)
      ..remove(product);
    final updatedCurrentValues =
        List<num>.from(state.orders[index].currentvalue)..remove(count);
    final updatedAllPrices = List<double>.from(state.orders[index].allPrice)
      ..remove(price);
    double updatedFinalPrice = updatedAllPrices.isNotEmpty
        ? updatedAllPrices.reduce((a, b) => a + b)
        : 0.0;
    final targetOrder = state.orders[index];
    final updatedOrder = targetOrder.copyWith(
      products: updatedProducts,
      currentvalue: updatedCurrentValues,
      allPrice: updatedAllPrices,
      totalprice: updatedFinalPrice,
    );
    final updatedOrders = List<Order>.from(state.orders);
    updatedOrders[index] = updatedOrder;

    emit(state.copyWith(orders: updatedOrders));
  }

  Future<void> removeOrder(Order order) async {
    await cubit.cancelOrder(order.id);
    final updatedOrders = state.orders.map((currentOrder) {
    if (currentOrder.id == order.id) {
      // Modify the specific field (e.g., status) of the matched order
      return currentOrder.copyWith(status: "cancelled" );
    }
    return currentOrder; // Keep other orders unchanged
  }).toList();
    emit(state.copyWith(orders: updatedOrders));
  }

  void productCount(num value, int valueIndex, int index) async {
    await cubit.updateOrderQuantity(state.orders[index].id,
        state.orders[index].products[valueIndex].id, value.toInt());
    final updatedCurrentValues =
        List<num>.from(state.orders[index].currentvalue);
    final updatedAllPrices = List<double>.from(state.orders[index].allPrice);

    updatedCurrentValues[valueIndex] = value;
    updatedAllPrices[valueIndex] =
        (state.orders[index].products[valueIndex].price * value).toDouble();
    double updatedFinalPrice = updatedAllPrices.reduce((a, b) => a + b);
    final targetOrder = state.orders[index];
    final updatedOrder = targetOrder.copyWith(
      currentvalue: updatedCurrentValues,
      allPrice: updatedAllPrices,
      totalprice: updatedFinalPrice,
    );
    final updatedOrders = List<Order>.from(state.orders);
    updatedOrders[index] = updatedOrder;

    emit(state.copyWith(orders: updatedOrders));
  }
}
