// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:talabat/models/order.dart';
import 'package:talabat/models/product.dart';

// Colors
const Color purple = Color.fromARGB(255, 68, 0, 194);
const Color primarycolor = Color.fromARGB(255, 194, 164, 255);
const Color homebackground = Color.fromARGB(255, 255, 208, 69);
const smallTextColor = Colors.white;
const Color black = Colors.black;

// translation decoding

Future<Map<String, dynamic>> loadTranslations() async {
  String jsonString = await rootBundle.loadString('assets/json/translate.json');
  return json.decode(jsonString);
}
//pop up window
void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required List<Widget> actions,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    },
  );
}

//Stripe
String publishKey="pk_test_51QI660I0U89wehgc4tmFTJ6LkzMctbOs9NqeHaloMyw1OAIymRsRKO96FG2S4fjUltXkHCkJ1iR9ctAmRojOuTDY00rvN0vR2A";
late String secretKey;
// products list for testing
// const List Products = [
//   {
//     "_id": "675d01de56989a18416c3502",
//     "name": "Product 1",
//     "description": "Description for Product 1",
//     "richDescription": "Rich description for Product 1",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 29.99,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 20,
//     "rating": 4.5,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:56:14.200Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
//   {
//     "_id": "675d023656989a18416c3506",
//     "name": "Product 2",
//     "description": "Description for Product 2",
//     "richDescription": "Rich description for Product 2",
//     "image": "https://picsum.photos/200/300",
//     "images": [],
//     "brand": "Brand A",
//     "price": 30.44,
//     "category": "675732261c031ad2a3a622e6",
//     "countInStock": 50,
//     "rating": 3.8,
//     "numReviews": 10,
//     "isFeatured": true,
//     "dateCreated": "2024-12-14T03:57:42.775Z",
//     "__v": 0
//   },
// ];

// // categories list for testing
// const List Categories = [
//   {
//     "_id": "675732261c031ad2a3a622e6",
//     "name": "computer",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "food",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "games",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "drink",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "clouth",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "any",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732261c031ad2a3a622e6",
//     "name": "computer",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "food",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "games",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
//   {
//     "_id": "675732451c031ad2a3a622e9",
//     "name": "drink",
//     "color": "",
//     "image": "https://picsum.photos/200/300",
//     "__v": 0
//   },
// ];
