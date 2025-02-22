import 'dart:convert';
import 'dart:io';

class User {
  final String token;
  final UserClass user;

  User({
    required this.token,
    required this.user,
  });
  User copyWith({
    String? token,
    UserClass? user,
  }) {
    return User(
      token: token ?? this.token,  // Use existing value if no new value provided
      user: user ?? this.user,      // Use existing user if no new user provided
    );
  }
  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) {
    print("Parsing User: $json"); // Print the entire JSON being parsed

    final token = json["token"]; // Safely handle null token
    print("Extracted token: $token"); // Print the extracted token

    final userJson = json["user"];
    if (userJson != null) {
      print("Parsing nested user: $userJson"); // Print the nested user JSON
    } else {
      print("No nested user found."); // Print if user is null
    }

    return User(
      token: token,
      user: UserClass.fromMap(userJson), // Parse the nested user if present
    );
  }

  Map<String, dynamic> toMap() => {
        "token": token,
        "user": user.toMap(),
      };
}

class UserClass {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  late final File? Picture;

  UserClass({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.Picture,
  });
  UserClass copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePicture,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    File? Picture
  }) {
    return UserClass(
      id: id ?? this.id, // Use existing value if no new value provided
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      Picture:Picture ?? this.Picture,
    );
  }

  factory UserClass.fromMap(Map<String, dynamic> json) => UserClass(
        id: json["id"] ?? 0,
        email: json["email"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        profilePicture: json["profile_picture"] ?? "",
        latitude: (json["latitude"] != null)
            ? double.tryParse(json["latitude"].toString()) ?? 0.0
            : 0.0,
        longitude: (json["longitude"] != null)
            ? double.tryParse(json["longitude"].toString()) ?? 0.0
            : 0.0,
        phoneNumber: json["phone_number"] ?? "",
        Picture: null
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": Picture,
        "latitude": latitude,
        "longitude": longitude,
        "phone_number": phoneNumber,
      };
}
// class User {
//   String first_name;
//   String last_name;
//   String email;

//   User({
//     required this.first_name,
//     required this.last_name,
//     required this.email,
//   });
// }
// // "first_name": "John",
// "last_name": "Doe",
// "email": "user@example.com",
// "phone_number": "+1234567890",
