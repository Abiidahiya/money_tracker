import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:money_tracker/uicomponents/buttons/back_button/back_button_bloc.dart';
import 'package:money_tracker/uicomponents/buttons/back_button/back_button_bloc.dart';
import 'package:money_tracker/uicomponents/buttons/back_button/back_button_bloc.dart';
import 'back_button_event.dart';
import 'back_button_state.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Dispatch the BackButtonPressed event
        context.read<BackButtonBloc>().add(BackButtonPressed());

        // Trigger the actual navigation
        Navigator.pop(context);  // This will pop the current screen from the stack
      },
    );
  }
}