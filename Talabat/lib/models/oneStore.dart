import 'package:meta/meta.dart';
import 'dart:convert';

class Onestore {
  final int id;
  final String name;
  final String description;

  final String image;
  final int OnestoreId;

  Onestore({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.OnestoreId = 0,
  });

  String toJson() => json.encode(toMap());

  factory Onestore.fromJson(Map<String, dynamic> json) => Onestore(
        id: json["id"],
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        image: json["image"] ?? "",
      );

  factory Onestore.fromJsonP(Map<String, dynamic> json) {
    return Onestore(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      OnestoreId: json['Onestore_id'],
    );
  }
  factory Onestore.fromCartJson(Map<String, dynamic> json) {
    return Onestore(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      OnestoreId: json['Onestore_id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'Onestore_id': OnestoreId,
    };
  }
}

class Onestores {
  final int currentPage;
  final List<Onestore> data;
  final int lastPage;
  final String? nextPageUrl;

  Onestores({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    this.nextPageUrl,
  });

  factory Onestores.fromCartJson(Map<String, dynamic> json) {
    // print(json['data']); // Ensure this is a List

    return Onestores(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((OnestoreJson) => Onestore.fromCartJson(OnestoreJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
  factory Onestores.fromJson(Map<String, dynamic> json) {
    // print(json); // Ensure this is a List

    return Onestores(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((OnestoreJson) => Onestore.fromJsonP(OnestoreJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
}
