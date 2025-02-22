import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:talabat/services/service.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<void> makePayment() async {
    try {
      // Step 1: Create a payment intent
      final paymentIntentData = await createPaymentIntent('2000', 'usd'); // $20.00

      // Step 2: Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Your App Name',
        ),
      );

      // Step 3: Display the payment sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful!")),
      );
    } catch (e) {
      print("Payment Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stripe Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: makePayment,
          child: Text('Pay 20'),
        ),
      ),
    );
  }
  
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  try {
    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': amount, // Pass amount in smallest unit (e.g., cents for USD)
        'currency': currency,
      }),
    );

    return json.decode(response.body);
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to create payment intent");
  }
}
}