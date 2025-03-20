import 'package:equatable/equatable.dart';
abstract class SettingsState {}
class SettingsInitial extends SettingsState {}

class SettingsNavigated extends SettingsState {}

class ContainerVisibilityState extends Equatable {
  final List<bool> containerVisibility;

  const ContainerVisibilityState(this.containerVisibility);

  @override
  List<Object> get props => [containerVisibility];
}
