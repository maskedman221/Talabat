import 'package:flutter/material.dart';
import 'package:talabat/core/cubit/languagecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/utils/constants.dart';

class CustomSwitch extends StatefulWidget {
  final Function(int) onSwitch; // Callback to notify parent

  const CustomSwitch({super.key, required this.onSwitch}); // Pass the callback

  @override
  State<CustomSwitch> createState() => _CustomSwitch();
}

class _CustomSwitch extends State<CustomSwitch> {
  int selectedIndex = 0; // Track the selected index
  final languageCubit = getIt<LanguageCubit>();

  void switchTab(int index) {
    setState(() {
      selectedIndex = index; // Update selected index
    });
    widget.onSwitch(index); // Notify parent about the switch
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColorLogin = selectedIndex == 0 ? purple : Colors.transparent;
    Color buttonColorSignup = selectedIndex == 1 ? purple : Colors.transparent;
    Color textColorLogin = selectedIndex == 0 ? Colors.white : purple;
    Color textColorSignup = selectedIndex == 1 ? Colors.white : purple;

    return Center(
      child: Container(
        height: 55,
        width: 200,
        decoration: const BoxDecoration(
          color: primarycolor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          children: [
            // Login button
            Expanded(
              child: GestureDetector(
                onTap: () => switchTab(0), // Switch to login tab
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: buttonColorLogin,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      languageCubit.state.lang!['Auth']["login"],
                      style: TextStyle(
                        color: textColorLogin,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Sign Up button
            Expanded(
              child: GestureDetector(
                onTap: () => switchTab(1), // Switch to signup tab
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: buttonColorSignup,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      languageCubit.state.lang!['Auth']["signUp"],
                      style: TextStyle(
                        color: textColorSignup,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
