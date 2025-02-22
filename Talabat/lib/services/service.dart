import 'dart:core';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/oneStore.dart';
import 'package:talabat/models/order.dart';
import 'package:talabat/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talabat/models/section.dart';
import 'package:talabat/models/store.dart';
import 'package:talabat/models/user.dart';
import 'package:talabat/utils/constants.dart'; // Import for JSON encoding/decoding

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ',
          'Content-Type': 'application/json',
         
        'locale': 'en', // Replace with your token
      },
    ),
  );
  // final String baseurl =
  // 'https://6752d5e3f3754fcea7b9c5fe.mockapi.io/test/v1/product'; //+963 954193681
  // Local API URL
  final String baseUrl2 = 'http://127.0.0.1:8000'; // Local API URL

  late Response response;

  
  
  Future<void> setHeaders(String locale) async {
    String? token = await getToken();
    print(token);
    dio.options.headers = {
         'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'locale': locale, // Set the locale dynamically
    'Content-Type': 'application/json',
    };
  }

  Future<String?> getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? token = sharedPreferences
        .getString('token'); // 'token' is the key where your token is stored.
    return token;
  }

  Future<Map<String, dynamic>> getHome() async {
    try {
      final response = await dio.get('/home');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch home: $e');
    }
  }

 Future<List<Product>> getProducts({
  String? query,
  int? sectionId,
  int? storeId,
  int? page,
  // String? locale,
}) async {
//  await setHeaders(locale!);  
  try {
    // Construct query parameters
    final Map<String, dynamic> queryParams = {
      if (query != null && query.isNotEmpty) 'search': query,
      if (sectionId != null) 'section_id': sectionId,
      if (storeId != null) 'store_id': storeId,
      if (page != null) 'page': page,
    };

    // Print the query params for debugging
    print('Query Params: $queryParams');

    // Make the Dio GET request
    final response = await dio.get(
      "$baseUrl/products",
      queryParameters: queryParams,
    );

    // Log the entire response for debugging
    print('Response Data: ${response.data}');

    // Ensure the response is successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = response.data;

      // Access the list of products from the 'data' key
      final List<dynamic>? productList =
          jsonResponse['products']['data'] as List<dynamic>?;
      print("Product List: $productList");

      List<Product> products = [];

      // Check if productList is not null and is a List
      if (productList != null) {
        for (var item in productList) {
          if (item is Map<String, dynamic>) {
            products.add(Product.fromJson(item)); // Convert map to Product object
          }
        }
      } else {
        print('No products found or invalid format');
      }

      // Print the retrieved products for debugging
      print('Parsed Products: $products');
      return products;
    } else {
      print('Failed to fetch products: ${response.statusMessage}');
    }
  } catch (e) {
    print('Failed to fetch products: $e');
  }

  // Return an empty list in case of failure
  return [];
}

  // Future getProducts() async {
  //   response = await dio.get(baseUrl);
  //   List<Product> products = [];
  //   for (var item in response.data) {
  //     products.add(Product.fromMap(item as Map<String, dynamic>));
  //   }
  //   return products;
  // }
  Future<List<Onestore>> getStores({String? query, int? page}) async {
    try {
      // Construct the URL with query parameters
      // Use query param encoding for the search term and append section_id and store_id if provided
      final Uri url = Uri.parse("$baseUrl/stores?${query != null && query.isNotEmpty
                  ? "search=$query"
                  : ""}${page != null
                  ? "&page=$page"
                  : ""}" // Include page if it's not null
          );
      print(url);
      // Make the HTTP GET request
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Log the entire response for debugging
      print('Response Data: ${response.body}');

      // Ensure the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Access the list of products from the 'data' key
        final List<dynamic>? storeList =
            jsonResponse['stores']['data'] as List<dynamic>?;
        print("Product List: $storeList");

        List<Onestore> stores = [];

        // Check if productList is not null and is a List
        if (storeList != null) {
          for (var item in storeList) {
            if (item is Map<String, dynamic>) {
              stores
                  .add(Onestore.fromJson(item)); // Convert map to Product object
            }
          }
        } else {
          print('No products found or invalid format');
        }

        // Print the retrieved products for debugging
        print('Parsed Products: $stores');
        return stores;
      } else {
        print('Failed to fetch products: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to fetch products: $e');
    }

    // Return an empty list in case of failure
    return [];
  }

  Future<Products> fetchProducts({required int page}) async {
    try {
      final response =
          await dio.get('/products', queryParameters: {'page': page});

      if (response.statusCode == 200) {
        print('201');
        return Products.fromJson(response.data['products']);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        print('Dio error! Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch products');
    }
  }

  Future<Sections> fetchSections({required int page}) async {
    try {
      final response =
          await dio.get('/sections', queryParameters: {'page': page});

      if (response.statusCode == 200) {
        // print('200');
        return Sections.fromJson(response.data['sections']);
      } else {
        throw Exception('Failed to load sections');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        print('Dio error! Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch sections');
    }
  }

  Future<Stores> fetchStores({required int page, String? query}) async {
    try {
      // Construct the query parameters
      final Map<String, dynamic> queryParameters = {'page': page};

      if (query != null && query.isNotEmpty) {
        queryParameters['search'] = query; // Add the search query if provided
      }

      final response =
          await dio.get('/stores', queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return Stores.fromJson(response.data['stores']);
      } else {
        throw Exception('Failed to load stores');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        print('Dio error! Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch stores');
    }
  }

  Future<Products> fetchCartProducts({required int page}) async {
    try {
      final response = await dio.get('/cart', queryParameters: {'page': page});
      //  print('Response data: ${response.data}'); // Print the data for debugging
      if (response.statusCode == 200) {
        print('200');
        return Products.fromCartJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        print('Dio error! Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch products');
    }
  }

  addToCart(int id, int quantity) async {
    try {
      final response = await dio.post(
        '/cart', // Endpoint
        data: {
          'product_id': id,
          'quantity': quantity
        }, // Data to send in the POST body
      );

      print('Item added to cart: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<void> updateCart(int id, int quantity) async {
    try {
      final response = await dio.put(
        '/cart',
        data: {
          'product_id': id,
          'quantity': quantity
        }, //  // Convert Product to JSON
      );

      print('Cart updated: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<void> deleteFromCart(int id) async {
    try {
      final response = await dio.delete(
        '/cart/remove',
        data: {
          'product_id': id,
        }, // Use productId in the URL
      );

      print('Product deleted from cart: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<void> clearCart() async {
    try {
      final response = await dio.delete(
        '/cart/clear',
        // Use productId in the URL
      );

      print('from cart: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await dio.get('/orders');
      print('Response data: ${response.data["orders"]}');

      List<Order> orders = List.generate(
        response.data["orders"].length,
        (index) => Order.fromMap(
          response.data["orders"][index],
        ),
      );
      return orders;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
      return [];
    }
  }

  Future<Response> checkout(String paymentId) async {
      try {
      final response = await dio.post(
        '/orders/checkout', data:{ "payment_intent_id":paymentId}// Endpoint
      );
      
      print('statue message: ${response.data}');
    
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
        return response;
      } else {
        print('Request Error: ${e.message}');
        return response;
      }
    }
  }
    Future<Response> paymentIntent() async {
      try {
      final response = await dio.post(
        '/payment/create-intent', // Endpoint
      );
      
      print('statue message: ${response.data}');
    
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
        return response;
      } else {
        print('Request Error: ${e.message}');
        return response;
      }
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      final response = await dio.post(
        '/orders/$id/cancel', // Endpoint
      );
      print('statue message: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<void> updateOrderQuantity(int id, int product_id, int quantity) async {
    try {
      final response = await dio.put(
        '/orders/$id/quantity',
        data: {
          'product_id': product_id,
          'quantity': quantity
        }, //  // Convert Product to JSON // Endpoint
      );
      print('statue message: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<void> deleteProductOrder(int id, int product_id) async {
    try {
      final response = await dio.delete(
        '/orders/$id/products',
        data: {
          'product_id': product_id,
        }, //  // Convert Product to JSON // Endpoint
      );
      print('statue message: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Request Error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse("https://your-backend-url.com/create-payment-intent"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount':
              amount, // Pass amount in smallest unit (e.g., cents for USD)
          'currency': currency,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to create payment intent");
    }
  }

  Future<void> loginUser(Map<String, dynamic> credentials) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(credentials),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User logged in successfully');
        // Optionally, handle successful login, e.g., parse the response body
        // var responseData = jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to log in user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to log in user: $e');
      throw Exception('Failed to log in user: $e');
    }
  }

  Future<void> logoutUser() async {
    final url = Uri.parse(
        '$baseUrl/api/auth/logout'); // Ensure your baseUrl is properly defined

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to register user: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  Future<void> VerifyingNumber(Map<String, dynamic> user) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/auth/verify-code',
        data: jsonEncode(user),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Verified successfully');
      } else {
        throw Exception(
            'Failed to verify number. Status code: ${response.statusCode}, Response: ${response.data}');
      }
    } catch (e) {
      print('Failed to verify number: $e');
      throw Exception('Failed to verify number: $e');
    }
  }

//   Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
//   try {
//     final response = await http.post(
//       Uri.parse("https://your-backend-url.com/create-payment-intent"),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'amount': amount, // Pass amount in smallest unit (e.g., cents for USD)
//         'currency': currency,
//       }),
//     );

//     return json.decode(response.body);
//   } catch (e) {
//     print("Error: $e");
//     throw Exception("Failed to create payment intent");
//   }
// }
Future<List<Product>> getFavorite() async{
  
  try{
  final response= await dio.get('/favorite');
   List<Product> favorites = List.generate(
        response.data["favorites"].length,
        (index) => Product.fromJsonF(
          response.data["favorites"][index],
        ),
      );
      
      print('////////////////////////////');
  return favorites;
  }
  catch (e){
    print("failed loading fav ${e.toString()}");
    return [];
  }
}
Future<void> postFavorite(int id) async{
  try{
  final response = await dio.post('/favorite/$id');
  if ( response.statusCode == 200) {
        print('added successfully');
  }
  }
  catch  (e){
    print("error adding fav ${e.toString()}");
  }
}
Future<void> deleteFavorite(int id)async{
  try{
    final response = await dio.delete('/favorite/$id');
    if(response.statusCode==200){
      print("deleted successfully");
    }
  }
  catch (e){
    print('error deleting fav ${e.toString()}');
  }
}


  Future<void> updateProfile(UserClass user) async {
  try {
    // Create a FormData object
    FormData formData = FormData.fromMap({
      "first_name": user.firstName,
      "last_name": user.lastName,
      "email": user.email,
      "phone_number": user.phoneNumber,
      "latitude": user.latitude,
      "longitude": user.longitude,
      // Convert the File to MultipartFile
      if (user.Picture != null)
        "profile_picture": await MultipartFile.fromFile(
          user.Picture!.path, // Path of the file
          filename: user.Picture!.path.split('/').last, // Extract the filename
        ),
    });

    // Send the request
    final response = await dio.post(
      '/user/profile?_method=put',
      data: formData,
    );

    // Handle the response
    print('Status message: ${response.data}');
  } on DioException catch (e) {
    // Handle Dio errors
    if (e.response != null) {
      print('Error: ${e.response?.statusCode} - ${e.response?.data}');
    } else {
      print('Request Error: ${e.message}');
    }
  }
}
  Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Get the token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Save the token for future use (e.g., sending it to your backend)
  if (token != null) {
    // Send the token to your backend or save locally
  }
}

}
