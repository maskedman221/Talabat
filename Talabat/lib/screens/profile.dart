import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/authentication/AuthPage.dart';
import 'package:talabat/authentication/changepassword.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/profilecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/user.dart';
import 'package:talabat/screens/favorite.dart';
import 'package:talabat/services/authApis.dart';
import 'package:talabat/services/location.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/map.dart';
import 'package:talabat/widgets/netImage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key}); // Ensure immutability by using const.

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

// ignore: non_constant_identifier_names
class _ProfileState extends State<ProfileScreen> {
  final profileCubit = getIt<ProfileCubit>();
  final AuthApis authApis = AuthApis();
  final Location location = Location();
  final languageCubit = getIt<LanguageCubit>();
  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    void _setLocation() async {
      try {
        Position position = await location.determinePosition();
        await profileCubit.updateUserLocation(
            position.latitude, position.longitude);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MapWithGeolocator()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('turn your mobile location on')));
      }
    }

    void _resetPassword() {
      print("object");
    }

    void _logout() async {
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        print(sharedPreferences.getString("token"));
        await authApis.logoutUser(sharedPreferences.getString("token"));

        // Handle success
        profileCubit.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User logout successfully')),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('user logout failed: ${e.toString()}')),
        );
      }
    }

    return Column(
      children: [
        AppBar(
          title: Text(
            languageCubit.state.lang!['profile'],
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor),
          ),
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            profileCubit.pickImage();
                          },
                          child: state.image != null || state.image != ""
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage("$baseUrl${state.image}"))
                              : CircleAvatar(
                                  radius: 50,
                                  child: Icon(Icons.person, size: 80),
                                ),
                        ),
                      ),
                      state.isLoggedin
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${state.user!.user.firstName} ${state.user!.user.lastName}",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  state.user!.user.phoneNumber,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            )
                          : MaterialButton(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.login_rounded,
                                    color: purple,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    languageCubit.state.lang!["Auth"]["login"],
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AuthPage()));
                              }),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Stack(children: [
                      Column(
                        children: [
                          MaterialButton(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: purple,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    languageCubit.state.lang!["language"],
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _showLanguageSelectionSheet(context);
                              }),
                          MaterialButton(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: purple,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    languageCubit.state.lang!["favorite"],
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (state.isLoggedin) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => languageCubit
                                                  .state.isEnglish
                                              ? Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: FavoriteScreen())
                                              : Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: FavoriteScreen())));
                                }
                              }),
                          state.isLoggedin
                              ? MaterialButton(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_city,
                                        color: purple,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        languageCubit.state.lang!["ContactUs"]
                                            ["location"],
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    _setLocation();
                                  })
                              : const SizedBox.shrink(),
                          state.isLoggedin
                              ? MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Changepassword()));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.password_rounded,
                                        color: purple,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        languageCubit.state.lang!['Auth']
                                            ['changePassword'],
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          state.isLoggedin
                              ? MaterialButton(
                                  onPressed: _logout,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout_rounded,
                                        color: purple,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        languageCubit.state.lang!['Auth']
                                            ['logout'],
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ]),
                  ),
                ],
              );
            }),
      ],
    );
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    final languageCubit = getIt<LanguageCubit>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return BlocBuilder(
            bloc: languageCubit,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
                  children: [
                    Text(
                      "Choose Language",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text("English"),
                      onTap: () {
                        // Handle language change to English

                        languageCubit.toggleLanguage(true);
                        print(languageCubit.state.lang);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text("العربية"),
                      onTap: () {
                        // Handle language change to Arabic
                        print("Arabic selected");

                        languageCubit.toggleLanguage(false);
                        print(languageCubit.state.lang);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

void _showLanguageSelectionSheet(BuildContext context) {
  final languageCubit = getIt<LanguageCubit>();
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return BlocBuilder(
          bloc: languageCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjust height based on content
                children: [
                  Text(
                    "Choose Language",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("English"),
                    onTap: () async {
                      // Handle language change to English

                      await languageCubit.toggleLanguage(true);
                      print(languageCubit.state.lang);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("العربية"),
                    onTap: () async {
                      // Handle language change to Arabic
                      print("Arabic selected");

                      await languageCubit.toggleLanguage(false);
                      print(languageCubit.state.lang);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    },
  );
}
