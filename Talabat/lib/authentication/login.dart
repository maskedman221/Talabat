import 'package:flutter/material.dart';
import 'package:talabat/authentication/forgotpassword.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/cubit/profilecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/models/user.dart';
import 'package:talabat/services/authApis.dart';
import 'package:talabat/services/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthApis authApis = AuthApis();

  final profileCubit=getIt<ProfileCubit>();
  
  final languageCubit = getIt<LanguageCubit>();
  final cubit=getIt<ApiService>();
  final TextEditingController _identifierController =
      TextEditingController(); // For email or phone
  final TextEditingController _passwordController = TextEditingController();
    

  // Form validation keys
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> credentials = {
        'phone_number': _identifierController.text,
        'password': _passwordController.text,
      };

      try {
       User user= await authApis.loginUser(credentials);
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
        profileCubit.loggedIn(true,user);
        profileCubit.saveProfileData();
        cubit.setHeaders(languageCubit.state.isEnglish? 'en' : 'ar');
        // Navigate to the home page
        Navigator.popUntil(
          context,
          (Route<dynamic> route) =>
              route.isFirst, // This will pop until the first route
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(languageCubit.state.lang!['Auth']["login"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _identifierController,
                decoration: InputDecoration(
                  labelText: languageCubit.state.lang!['Auth']["mobilePhone"],
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number" ;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: languageCubit.state.lang!['Auth']["password"],
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Forgotpassword()));
                  },
                  child: Text(languageCubit.state.lang!['Auth']['forgetpassword'] ?? "forget password ?")),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: MaterialButton(
                  onPressed: _login,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  height: 50,
                  minWidth: 200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child:  Text(
                    languageCubit.state.lang!['Auth']['login'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
