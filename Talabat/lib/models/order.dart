  import 'dart:convert';

import 'package:talabat/models/product.dart';

// class Orders {
//     final List<Order> orders;

//     Orders({
//         required this.orders,
//     });

//     factory Orders.fromJson(String str) => Orders.fromMap(json.decode(str));

//     // String toJson() => json.encode(toMap());

//     factory Orders.fromMap(Map<String, dynamic> json) => Orders(
//         orders: List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
//     );

//     // Map<String, dynamic> toMap() => {
//     //     "orders": List<dynamic>.from(orders.map((x) => x.toMap())),
//     // };
// }
class Order {
  final List<Product> products;
  final String date;
  final String status;
  late final List<num> currentvalue;  // Make it non-nullable
  late final List<double> allPrice;   // Make it non-nullable
  late final double totalprice;
  final bool isExpanded;
  final int id;

  Order({
    required this.products,
    required this.status,
    required this.date,
    required this.totalprice,
    required this.id,
    required this.currentvalue, // Make sure this is non-nullable
    required this.allPrice,     // Make sure this is non-nullable
    required this.isExpanded,
  });

  factory Order.initial() => Order(
    products: [],
    id: 0,
    status: "",
    totalprice: 0.0,
    currentvalue: [],  // Default to an empty list
    allPrice: [],      // Default to an empty list
    date: "",
    isExpanded: false,
  );

  Order copyWith({
    List<Product>? products,
    String? date,
    String? status,
    List<num>? currentvalue,
    List<double>? allPrice,
    double? totalprice,
    bool? isExpanded,
    int? id,
  }) {
    return Order(
      products: products ?? this.products,
      status: status ?? this.status,
      date: date ?? this.date,
      totalprice: totalprice ?? this.totalprice,
      currentvalue: currentvalue ?? this.currentvalue,
      allPrice: allPrice ?? this.allPrice,
      isExpanded: isExpanded ?? this.isExpanded,
      id: id ?? this.id,
    );
  }

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    products: (json['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList(),
    id: json["id"],
    date: (json["created_at"] as String).split("T").first,
    status: json["status"],
    totalprice: json["total_price"] ?? 0.0,
    currentvalue: [],   // Default empty list if not present in the JSON
    allPrice: [],       // Default empty list if not present in the JSON
    isExpanded: false,
  );
}
    // Map<String, dynamic> toMap() => {
    //     "id": id,
    //     "status": status,
    //     "total_price": totalprice,
    //     "created_at": date.toIso8601String(),
    //     "products": List<dynamic>.from(products.map((x) => x.toMap())),
    // };
  // }
  // class Product {
  //   final int id;
  //   final dynamic name;
  //   final dynamic description;
  //   final int price;
  //   final int quantity;

  //   Product({
  //       required this.id,
  //       required this.name,
  //       required this.description,
  //       required this.price,
  //       required this.quantity,
  //   });

  //   factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  //   String toJson() => json.encode(toMap());

  //   factory Product.fromMap(Map<String, dynamic> json) => Product(
  //       id: json["id"],
  //       name: json["name"],
  //       description: json["description"],
  //       price: json["price"],
  //       quantity: json["quantity"],
  //   );

  //   Map<String, dynamic> toMap() => {
  //       "id": id,
  //       "name": name,
  //       "description": description,
  //       "price": price,
  //       "quantity": quantity,
  //   };
// }
