import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication/auth_bloc.dart';

import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:money_tracker/utils/constants/dimen.dart';
import 'package:money_tracker/utils/app_string_res.dart';
import 'package:money_tracker/utils/constants/font_size_constraints.dart';
import 'package:money_tracker/utils/constants/color.dart';

import '../bloc/authentication/auth_event.dart';
import '../bloc/authentication/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/login_wallpaper.PNG', // Ensure the image is correctly located in your assets
            fit: BoxFit.cover, // Scales the image to cover the screen
            width: double.infinity, // Ensure the image takes up full width
            height: double.infinity, // Ensure the image takes up full height
          ),
          // App name in stylish fonts at the top half
          Positioned(
            top: Dimen_100, // Position the text in the center of the top half
            left: Dimen_20,
            right: Dimen_20,
            child: Text(
              app_name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 70, // Large font size
                fontWeight: FontWeight.bold, // Bold font style
                color: Colors.white, // White color for the text
                fontFamily: 'Roboto', // Use a stylish font family
                letterSpacing: 2, // Letter spacing for a stylish look
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: semiTransparentBlack,
                    offset: Offset(Dimen_2, Dimen_2),
                  ),
                ],
              ),
            ),
          ),
          // Positioned Login Button at the Bottom
          Positioned(
            bottom: Dimen_50, // Position the button slightly above the bottom
            left: Dimen_20,
            right: Dimen_20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimen_20),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    // No need to navigate here; the BlocBuilder in main.dart handles it
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInRequested());
                    },
                    icon: Icon(
                      FontAwesome.google, // Use the Google icon from FontAwesome
                      size: 20,
                      color: Colors.white, // Set the icon color to white
                    ),
                    label: Text(
                      login,
                      style: TextStyle(fontSize: mediumFontSize, color:white), // Text style
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: Dimen_15, horizontal: Dimen_40),
                      ),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimen_30), // Rounded corners
                      )),
                      elevation: WidgetStateProperty.all(Dimen_5),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}