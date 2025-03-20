import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import 'package:flutter/material.dart';
import 'package:money_tracker/pages/settings_page/settings_page_event.dart';
import 'package:money_tracker/pages/settings_page/settings_page_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is NavigateToSettings) {
      yield SettingsNavigated(); // Yield state indicating that navigation should happen
    }
  }
}

class ContainerVisibilityBloc
    extends Bloc<ContainerVisibilityEvent, ContainerVisibilityState> {
  ContainerVisibilityBloc()
      : super(const ContainerVisibilityState([true, true, true, true, true])) {
    on<ToggleContainerVisibility>(_onToggleContainerVisibility);
  }

  void _onToggleContainerVisibility(
      ToggleContainerVisibility event,
      Emitter<ContainerVisibilityState> emit,
      ) {
    final newVisibility = List.of(state.containerVisibility);
    newVisibility[event.containerIndex] = event.isVisible;
    emit(ContainerVisibilityState(newVisibility));
  }
}