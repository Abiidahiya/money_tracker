import 'package:equatable/equatable.dart';

abstract class RecipientEvent extends Equatable {
  const RecipientEvent();
  @override
  List<Object?> get props => [];
}

class FetchRecipients extends RecipientEvent {
  final bool forceUpdate; // 🔥 Add this property

  FetchRecipients({this.forceUpdate = false});
}
class ReorderRecipients extends RecipientEvent {
  final int oldIndex;
  final int newIndex;

  ReorderRecipients({required this.oldIndex, required this.newIndex});

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
class DeleteRecipient extends RecipientEvent {
  final String recipientId;

  const DeleteRecipient(this.recipientId);

  @override
  List<Object> get props => [recipientId];
}