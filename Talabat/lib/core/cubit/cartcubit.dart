import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talabat/core/cubit/productcubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/services/service.dart';
import 'package:talabat/utils/constants.dart';
import 'package:stripe_platform_interface/src/models/payment_intents.dart';

class CartState {
  final List<Product> products;
  final bool hasProducts;
  final bool isLoading;
  final bool isLoaded;
  final String? error;
  final List<num> currentvalue;
  final List<double> allPrice;
  final double finalprice;
  final Map<String, dynamic> paymentData;
  final int currentPage;
  final bool hasMore;
  CartState({
    required this.products,
    required this.hasProducts,
    required this.isLoading,
    required this.isLoaded,
    required this.currentvalue,
    required this.allPrice,
    required this.finalprice,
    required this.paymentData,
    required this.currentPage,
    required this.hasMore,
    this.error,
  });

  factory CartState.initial() => CartState(
        products: [],
        currentvalue: [],
        allPrice: [],
        finalprice: 0.0,
        hasProducts: false,
        isLoading: false,
        isLoaded: false,
        paymentData: {},
        error: null,
        currentPage: 1,
        hasMore: true,
      );

  CartState copyWith({
    List<Product>? products,
    List<num>? currentvalue,
    List<double>? allPrice,
    bool? hasProducts,
    bool? isLoading,
    bool? isLoaded,
    double? finalprice,
    Map<String, dynamic>? paymentData,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return CartState(
      products: products ?? this.products,
      currentvalue: currentvalue ?? this.currentvalue,
      allPrice: allPrice ?? this.allPrice,
      hasProducts: hasProducts ?? this.hasProducts,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      finalprice: finalprice ?? this.finalprice,
      paymentData: paymentData ?? this.paymentData,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  final cubit = getIt<ApiService>();
  final _editCart = PublishSubject<Map<String, int>>();
  final productCubit = getIt<ProductCubit>();
  CartCubit() : super(CartState.initial()) {
    // Initialize debounced API call
    _editCart.debounceTime(Duration(milliseconds: 500)).listen((update) {
      _updateCartAPI(update['product_Id']!, update['quantity']!);
    });
  }

  Future<void> addProduct(Product product) async {
    
    await cubit.addToCart(product.id, 1);
    final updatedProducts = List<Product>.from(state.products)..add(product);
    final updatedCurrentValues = List<num>.from(state.currentvalue)..add(1);
    final updatedAllPrices = List<double>.from(state.allPrice)
      ..add(product.price.toDouble());
    double updatedFinalPrice = updatedAllPrices.reduce((a, b) => a + b);

    emit(state.copyWith(
        products: updatedProducts,
        hasProducts: updatedProducts.isNotEmpty,
        allPrice: updatedAllPrices,
        currentvalue: updatedCurrentValues,
        finalprice: updatedFinalPrice));
  }

  Future<void> removeProduct(Product product, num count, double price) async {
    final updatedProducts = List<Product>.from(state.products)..remove(product);
    final updatedCurrentValues = List<num>.from(state.currentvalue)
      ..remove(count);
    final updatedAllPrices = List<double>.from(state.allPrice)..remove(price);
    double updatedFinalPrice = updatedAllPrices.isNotEmpty
        ? updatedAllPrices.reduce((a, b) => a + b) // Sum all prices
        : 0.0; // Default to 0 if the list is empty
    emit(state.copyWith(
        products: updatedProducts,
        hasProducts: updatedProducts.isNotEmpty,
        allPrice: updatedAllPrices,
        currentvalue: updatedCurrentValues,
        finalprice: updatedFinalPrice));
    await cubit.deleteFromCart(product.id);
  }

Future<void> loadCartProducts(int page) async {
  // Prevent redundant calls if already loading or all products are loaded
  if (state.isLoading || state.isLoaded) return;

  emit(state.copyWith(isLoading: true, error: null));

  try {
    // Fetch products from the API
    final productsResponse = await cubit.fetchCartProducts(page: state.currentPage);
    final products = productsResponse.data;

    if (products.isEmpty) {
      // If no products returned, set hasMore to false
      emit(state.copyWith(isLoading: false, hasMore: false));
      return;
    }

    // Initialize quantities and prices
    final currentQuantities = List<num>.generate(
      products.length,
      (index) => products[index].quantity,
    );

    final allPrices = List<double>.generate(
      products.length,
      (index) => products[index].quantity * products[index].price.toDouble(),
    );

    // Calculate the total price
    final totalPrice = allPrices.fold(0.0, (sum, price) => sum + price);

    // Emit updated state with new data
    emit(state.copyWith(
      products: [...state.products, ...products], // Append new products
      hasProducts: state.products.isNotEmpty || products.isNotEmpty,
      isLoading: false,
      allPrice: [...state.allPrice, ...allPrices], // Append new prices
      currentvalue: [...state.currentvalue, ...currentQuantities], // Append quantities
      finalprice: state.finalprice + totalPrice, // Update total price
      currentPage: state.currentPage + 1,
      hasMore: productsResponse.nextPageUrl != null,
    ));
  } catch (e) {
    // Handle errors and emit the error state
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}
  void productCount(num value, int index) {
    final updatedCurrentValues = List<num>.from(state.currentvalue);
    final updatedAllPrices = List<double>.from(state.allPrice);

    updatedCurrentValues[index] = value;
    updatedAllPrices[index] = (state.products[index].price * value).toDouble();
    double updatedFinalPrice = updatedAllPrices.reduce((a, b) => a + b);
    emit(state.copyWith(
        currentvalue: updatedCurrentValues,
        allPrice: updatedAllPrices,
        finalprice: updatedFinalPrice));
    _editCart.add({
      'product_Id': state.products[index].id,
      'quantity': value.toInt(),
    });
  }

  confirmOrder(BuildContext context) async {
    try {
      // Step 1: Create a PaymentIntent from your backend
      Response response = await cubit.paymentIntent();
      print(response.data["clientSecret"]);
      Response? checkoutResponse;

      if (response.statusCode == 200) {
        // Step 2: Initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: response.data["clientSecret"],
            merchantDisplayName: 'Your Business Name',
          ),
        );

        // Step 3: Present the payment sheet
        try {
          await Stripe.instance.presentPaymentSheet();

          // Step 4: Call checkout only if payment succeeds
          checkoutResponse = await cubit.checkout(response.data["payment_id"]);

          if (checkoutResponse.statusCode == 200) {
            // Clear cart or perform additional actions
            final orderProducts = List<Product>.from(state.products);
            final orderTotalPrice = state.finalprice;
            emit(state.copyWith(
              products: [],
              currentvalue: [],
              allPrice: [],
              finalprice: 0.0,
              hasProducts: false,
            ));
            print("Order successfully confirmed!");
          }
        } on StripeException catch (e) {
          // Handle payment cancellation or failure
          print("Payment canceled or failed: ${e.error.localizedMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Payment canceled: ${e.error.localizedMessage}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Failed to process payment: ${e.toString()}");

      // Handle API or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  makePayment(double chargeAmount, String currency) async {
    Map<String, dynamic> paymentInfo = {
      "amount": chargeAmount,
      "currency": currency,
      "payment_method_types[]": "card"
    };
  }

  Future<void> _updateCartAPI(int product_Id, int quantity) async {
    try {
      await cubit.updateCart(product_Id, quantity);
      print("debouncing");
    } catch (e) {
      print("Error updating product $product_Id: $e");
    }
  }

  @override
  Future<void> close() {
    _editCart.close();
    return super.close();
  }
}
