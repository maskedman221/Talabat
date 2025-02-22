import 'package:meta/meta.dart';
import 'dart:convert';
class ProductClass {
  String name;
  String image;
  String color;
  String description;
  double price;
  
  ProductClass({required this.name,required this.image,required this.color,required this.description,required this.price});
    factory ProductClass .fromMap(Map<String, dynamic> json) => ProductClass (
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        image: json["image"],
        color: json["color"],
         
    );
}
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String image;
  final int storeId;
  late final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
    this.storeId=0,
    this.isFavorite=false,
  });
// factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"]  ?? "",
        description: json["description"] ?? "",
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        image: json["image"] ?? "",
    );

  factory Product.fromJsonP(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
      storeId: json['store_id'],
      isFavorite: json['is_favorite'],
    );
  }
  factory Product.fromJsonF(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
      storeId: json['store_id'],
      isFavorite: json['is_favorite'] ?? true,
    );
  }
  factory Product.fromCartJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'].toDouble(),
    quantity: json['cart_quantity'], // Assuming 'cart_quantity' is the correct key
    image: json['image'],
    storeId: json['store_id'],
  );
}
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image': image,
      'store_id': storeId,
    };
  }
}

class Products {
  final int currentPage;
  final List<Product> data;
  final int lastPage;
  final String? nextPageUrl;

  Products({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    this.nextPageUrl,
  });

  factory Products.fromCartJson(Map<String, dynamic> json) {
      // print(json['data']); // Ensure this is a List

    return Products(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((productJson) => Product.fromCartJson(productJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
    factory Products.fromJson(Map<String, dynamic> json) {
      // print(json); // Ensure this is a List

    return Products(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((productJson) => Product.fromJsonP(productJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
}