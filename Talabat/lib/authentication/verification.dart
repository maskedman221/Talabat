import 'package:flutter/material.dart';
import 'package:talabat/authentication/login.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/authApis.dart';

class Verification extends StatefulWidget {
  final String email; // Add a field to hold the email
  final String phone_number;
  const Verification(
      {super.key,
      required this.email,
      required this.phone_number}); // Update the constructor

  @override
  State<Verification> createState() =>
      _VerificationState(email: email, phone_number: phone_number);
}

class _VerificationState extends State<Verification> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String email;
  final String phone_number;
  final languageCubit = getIt<LanguageCubit>();

  final AuthApis authApis = AuthApis();

  _VerificationState({required this.email, required this.phone_number});

  void _verify() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> user = {
        'email': email,
        "phone_number": phone_number,
        'phone_number_otp_code': _codeController.text,
      };

      try {
        await authApis.verifyingNumber(user);

        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Number verified successfully')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        // Handle error
        print("Verifying failed: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifying failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(languageCubit.state.lang!['Auth']['Verification']),
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Logo/Image at the top
            Image.asset(
              "assets/images/5087579.png",
              fit: BoxFit.contain,
              height: 150, // Set height to maintain consistency
            ),
            const SizedBox(height: 20),

            // Heading
             Text(
              languageCubit.state.lang!['Auth']['checkCode'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description text
            Text(
              languageCubit.state.lang!['Auth']['codeSent'],
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Form widget
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Text form field for input
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: languageCubit.state.lang!['Auth']['Verificationcode'],
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      prefixIcon: Icon(Icons.code, color: Colors.blueAccent),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the code';
                      } else if (value.length != 4) {
                        return 'The code length must be 4 numbers';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Resend code button
                  TextButton(
                    onPressed: () {
                      // Logic to resend the code goes here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resending code...')),
                      );
                    },
                    child:  Text(
                      languageCubit.state.lang!['Auth']['resendcode'],
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  // Confirm button
                  Center(
                    child: MaterialButton(
                      onPressed: _verify,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      height: 50,
                      minWidth: 200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child:  Text(
                        languageCubit.state.lang!['Auth']["confirm"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
