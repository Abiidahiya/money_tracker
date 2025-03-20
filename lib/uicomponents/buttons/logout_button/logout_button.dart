import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/authentication/auth_bloc.dart';
import '../../../bloc/authentication/auth_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  void _signOutRequested(BuildContext context) {
    context.read<AuthBloc>().add(SignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signOutRequested(context),
      child: Text("Logout"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}
