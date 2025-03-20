import 'package:equatable/equatable.dart';
abstract class SettingsEvent {}

class NavigateToSettings extends SettingsEvent {}

abstract class ContainerVisibilityEvent extends Equatable {
  const ContainerVisibilityEvent();
  @override
  List<Object> get props => [];
}

class ToggleContainerVisibility extends ContainerVisibilityEvent {
  final int containerIndex;
  final bool isVisible;

  const ToggleContainerVisibility(this.containerIndex, this.isVisible);

  @override
  List<Object> get props => [containerIndex, isVisible];
}