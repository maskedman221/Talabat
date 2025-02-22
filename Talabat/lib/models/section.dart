import 'dart:convert';

class Section {
    final int id;
    final String name;
    final String description;
    final String image;

    Section({
        required this.id,
        required this.name,
        required this.description,
        required this.image,
    });

    factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
    };
}
class Sections {
  final int currentPage;
  final List<Section> data;
  final int lastPage;
  final String? nextPageUrl;

  Sections({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    this.nextPageUrl,
  });


    factory Sections.fromJson(Map<String, dynamic> json) {
      //  print(json); // Ensure this is a List

    return Sections(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((sectionJson) => Section.fromMap(sectionJson))
          .toList(),
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }
}