import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:talabat/models/user.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApis {
  final String baseUrl = 'http://10.0.2.2:8000'; // Local API URL
  final String baseUrl2 = 'http://127.0.0.1:8000'; // Local API URL
    Future<String?> getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? token = sharedPreferences
        .getString('token'); // 'token' is the key where your token is stored.
    return token;
  }

  Future<void> registerUser(Map<String, dynamic> user) async {
    final url = Uri.parse(
        '$baseUrl/api/auth/register'); // Ensure your baseUrl is properly defined

    try {
      final response = await http.post(
        url,
        body: jsonEncode(user),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('User registered successfully');
      } else {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to register user: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  Future<User> loginUser(Map<String, dynamic> credentials) async {
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

      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Request sent successfully');
        var responseData = jsonDecode(response.body);
        print(responseData);

        // Ensure the expected fields are present
        if (responseData["user"]["first_name"] != "") {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("token", responseData["token"]);
          print(responseData["user"]);
          User user = User.fromMap(responseData);
          
          return user;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to log in user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to log in user: $e');
      throw Exception('Failed to log in user: $e');
    }
  }

  Future<void> ForgotpasswordApi(
      Map<String, dynamic> credentials, token) async {
    final url = Uri.parse('$baseUrl/api/auth/forgot-password');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(credentials),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('password changed successfully');
      } else {
        throw Exception(
            'Failed to change password. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to change password: $e');
      throw Exception('Failed to change password: $e');
    }
  }

  Future<void> logoutUser(token) async {
    final url = Uri.parse(
        '$baseUrl/api/auth/logout'); // Ensure your baseUrl is properly defined

    try {
      
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
        SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.remove("token");
          sharedPreferences.remove("username");
          sharedPreferences.remove("email");
      } else {
        throw Exception(
            'Failed to logout user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to logout user: $e');
      throw Exception('Failed to logout user: $e');
    }
  }

  Future<void> verifyingNumber(Map<String, dynamic> user) async {
    try {
      // Construct the URL for the POST request
      final Uri url = Uri.parse('$baseUrl/api/auth/verify-code');

      // Make the HTTP POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(user), // Send the user data as JSON
      );

      print('Response Headers: ${response.headers}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Verified successfully');
      } else {
        throw Exception(
            'Failed to verify number. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Failed to verify number: $e');
      throw Exception('Failed to verify number: $e');
    }
  }


  Future<void> changePassword(Map<String, dynamic> user, token) async {
    final url = Uri.parse(
        '$baseUrl/api/auth/reset-password'); // Ensure your baseUrl is properly defined

    try {
      final response = await http.post(
        url,
        body: jsonEncode(user),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response body: ${response.body}'); // Log headers

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('password changed successfully');
      } else {
        throw Exception(
            'Failed to change password');
      }
    } catch (e) {
      print('Failed to change password: ${e.toString()}');
      throw Exception('Failed to change password');
    }
  }

  Future<String?> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Get the token
  String? token = await messaging.getToken();
 
  print("FCM Token: $token");

  // Save the token for future use (e.g., sending it to your backend)
  if (token != null) {
    return token;
    // Send the token to your backend or save locally
  }
  else{
    return "";
  }
}
}
