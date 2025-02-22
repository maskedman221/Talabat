import 'dart:convert';

class Store {
    final int id;
    final String name;
    final int sectionId;
    final String image;

    Store({
        required this.id,
        required this.name,
         this.sectionId=0,
        required this.image,
    });

    factory Store.fromJson(String str) => Store.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Store.fromMap(Map<String, dynamic> json) => Store(
        id: json["id"],
        name: json["name"],
        sectionId: json["section_id"],
        image: json["image"],
    );
     factory Store.fromMapS(Map<String, dynamic> json) => Store(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "section_id":sectionId,
        "image": image,
    };
}
class Stores {
  final int currentPage;
  final List<Store> data;
  final int lastPage;
  final String? nextPageUrl;

  Stores({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    this.nextPageUrl,
  });


    factory Stores.fromJson(Map<String, dynamic> json) {
      //  print(json); // Ensure this is a List

    return Stores(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((sectionJson) => Store.fromMap(sectionJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
}