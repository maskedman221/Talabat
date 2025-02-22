import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/user.dart';
import 'package:talabat/services/service.dart';
import 'dart:io';
import 'package:talabat/services/shared_preferences_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProfileState {
  final ImagePicker imagePicker; // Image picker instance
  final File? profileImage; // User profile image file
  final bool isLoggedin; // Login status
  final User? user;
  final String? image; // User information

  ProfileState(
      {required this.imagePicker,
      required this.profileImage,
      required this.isLoggedin,
      required this.user,
      required this.image});

  factory ProfileState.initial() => ProfileState(
        imagePicker: ImagePicker(),
        profileImage: null,
        isLoggedin: false,
        user: null,
        image: "",
      );

  ProfileState copyWith({
    File? profileImage,
    bool? isLoggedin,
    User? user,
    String? image,
  }) {
    return ProfileState(
        imagePicker: imagePicker, // Retain the same picker instance
        profileImage: profileImage ?? this.profileImage,
        isLoggedin: isLoggedin ?? this.isLoggedin,
        user: user ?? this.user,
        image: image ?? this.image);
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final cubit = getIt<ApiService>();
  ProfileCubit() : super(ProfileState.initial());

  /// Log the user in and save their data
  Future<void> loggedIn(bool log, User user) async {
    // Check if the profilePicture is a URL (or local path)
    String profileImagePath = user.user.profilePicture;

    emit(state.copyWith(isLoggedin: log, user: user, image: profileImagePath));
    await saveProfileData();
  }

  /// Log the user out by clearing user-related data from SharedPreferencesService
  Future<void> logout() async {
    try {
      // Remove user-related data
      await SharedPreferencesService.removeData('isLoggedin');
      await SharedPreferencesService.removeData('profileImage');
      String? profileImage =
          await SharedPreferencesService.getData('profileImage');
          await SharedPreferencesService.removeData('image');
      print("Profile image after logout: $profileImage"); //
      await SharedPreferencesService.removeData('user');

      // Update the state to reflect the logged-out status
      emit(state.copyWith(
          isLoggedin: false, user: null, profileImage: null, image: ""));

      print("User logged out successfully.");
      print(state.image);
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  /// Save profile data to SharedPreferencesService
  Future<void> saveProfileData() async {
    try {
      // Save boolean value
      await SharedPreferencesService.saveData('isLoggedin', state.isLoggedin);

      // Save profile image path if available
      if (state.profileImage != null) {
        await SharedPreferencesService.saveData(
            'profileImage', state.profileImage!.path);
      }
      if (state.image != null) {
        await SharedPreferencesService.saveData(
            'image', state.image!);
      }
      // Save user object as JSON if available
      if (state.user != null) {
        final userJson =
            jsonEncode(state.user!.toMap()); // Serialize user to JSON
        await SharedPreferencesService.saveData('user', userJson);
      }
    } catch (e) {
      print("Error saving profile data: $e");
    }
  }

  /// Load profile data from SharedPreferencesService
  Future<void> loadProfileData() async {
    try {
      final isLoggedin =
          SharedPreferencesService.getData('isLoggedin') ?? false;
      final profileImagePath =
          SharedPreferencesService.getData('profileImage') as String?;
      final userJson = SharedPreferencesService.getData('user') as String?;
      final image=SharedPreferencesService.getData('image');

      // Deserialize JSON back to User object
      final user = userJson != null ? User.fromMap(jsonDecode(userJson)) : null;

      // Load profile image from path
      File? profileImage;
      if (profileImagePath != null) {
        profileImage = File(profileImagePath);
      }

      emit(state.copyWith(
        isLoggedin: isLoggedin,
        profileImage: profileImage,
        user: user,
        image: image
      ));
      print(user);
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  /// Pick an image and save it
  Future<void> pickImage() async {
    try {
      final XFile? pickedImage =
          await state.imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // Convert XFile to File
        File fileImage = File(pickedImage.path);

        // Update the user class with the profile picture path and File
        final updatedUserClass = state.user?.user.copyWith(
          profilePicture: pickedImage.path,
          Picture:
              fileImage, // Assuming `picture` is a `File` in your user model
        );

        if (updatedUserClass != null) {
          await cubit.updateProfile(updatedUserClass);

          // Update the state with the new profile image and user
          final updatedUser = state.user?.copyWith(user: updatedUserClass);
          emit(state.copyWith(profileImage: fileImage));
          emit(state.copyWith(user: updatedUser));

          // Save the updated profile data
          await saveProfileData();
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  /// Update user information and save it
  Future<void> updateUserLocation(double latitude, double longtitude) async {
    final updatedUserClass =
        state.user?.user.copyWith(latitude: latitude, longitude: longtitude);
    await cubit.updateProfile(updatedUserClass!);
    final updatedUser = state.user?.copyWith(user: updatedUserClass);
    emit(state.copyWith(user: updatedUser));
    await saveProfileData();
  }
}
