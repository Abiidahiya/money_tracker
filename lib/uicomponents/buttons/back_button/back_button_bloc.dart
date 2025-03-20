import 'package:bloc/bloc.dart';

import 'package:money_tracker/uicomponents/buttons/back_button/back_button_event.dart';
import 'package:money_tracker/uicomponents/buttons/back_button/back_button_state.dart';

class BackButtonBloc extends Bloc<BackButtonEvent, BackButtonState> {
  BackButtonBloc() : super(BackButtonInitial()) {
    // Register the event handler for BackButtonPressed
    on<BackButtonPressed>(_onBackButtonPressed);
  }

  void _onBackButtonPressed(
      BackButtonPressed event, Emitter<BackButtonState> emit) {
    // Trigger Navigator.pop() to go back to the previous screen
    // Note: This only works if the current screen is part of a navigation stack
    emit(BackButtonInitial()); // You can emit different states if needed
  }
}