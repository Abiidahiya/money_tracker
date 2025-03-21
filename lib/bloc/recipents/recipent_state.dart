
import 'package:equatable/equatable.dart';

import '../../data/models/recipent_model.dart';

abstract class RecipientState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecipientInitial extends RecipientState {}

class RecipientLoading extends RecipientState {}

class RecipientLoaded extends RecipientState {
  final List<Recipient> recipients;

  RecipientLoaded(this.recipients);

  @override
  List<Object?> get props => [recipients];
}

class RecipientError extends RecipientState {
  final String message;

  RecipientError(this.message);

  @override
  List<Object?> get props => [message];
}