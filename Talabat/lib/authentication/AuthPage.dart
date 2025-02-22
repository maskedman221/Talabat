import 'package:flutter/material.dart';
import 'package:talabat/authentication/login.dart'; // Ensure you import your LoginPage
import 'package:talabat/authentication/register.dart'; // Ensure you import your RegisterUserPage
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/widgets/CustomSwitch.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int selectedIndex = 0; // Track the selected index from CustomSwitch
  final languageCubit = getIt<LanguageCubit>();

  void _navigateToSelectedPage() {
    if (selectedIndex == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RegisterUserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside of the TextField
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/5087579.png",
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(languageCubit.state.lang!['Auth']["start"],
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 15),
                // CustomSwitch passes the selected index to the AuthPage
                CustomSwitch(
                  onSwitch: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 15),

                // Register/Login Button
                ElevatedButton(
                  onPressed: () {
                    _navigateToSelectedPage();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text(
                    languageCubit.state.lang!['Footer']["send"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}