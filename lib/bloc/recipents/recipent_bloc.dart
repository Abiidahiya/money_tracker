import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/recipents/recipent_event.dart';
import 'package:money_tracker/bloc/recipents/recipent_state.dart';

import '../../data/models/recipent_model.dart';
import '../../data/repositories/recipent_repository.dart';

class RecipientBloc extends Bloc<RecipientEvent, RecipientState> {
  final RecipientRepository _recipientRepository;

  List<Recipient> _recipients = [];
  bool _isReordering = false; // Flag to track reordering

  RecipientBloc(this._recipientRepository) : super(RecipientInitial()) {
    on<FetchRecipients>(_onFetchRecipients);
    on<ReorderRecipients>(_onReorderRecipients);
  }

  Future<void> _onFetchRecipients(
      FetchRecipients event,
      Emitter<RecipientState> emit,
      ) async {
    emit(RecipientLoading());
    try {
      await for (final recipients in _recipientRepository.getRecipients()) {
        // Allow state updates after reordering is finished
        if (!_isReordering || event.forceUpdate) {
          _recipients = recipients;
          if (recipients.isEmpty) {
            emit(RecipientError('No recipients found.'));
          } else {
            emit(RecipientLoaded(recipients));
          }
        }
      }
    } on FirebaseException catch (e) {
      emit(RecipientError(e.message ?? 'Failed to fetch recipients'));
    } catch (e) {
      emit(RecipientError('An unexpected error occurred: $e'));
    }
  }


  Future<void> _onReorderRecipients(
      ReorderRecipients event,
      Emitter<RecipientState> emit,
      ) async {
    if (event.oldIndex == event.newIndex) return;

    _isReordering = true; // Prevent unnecessary state updates

    try {
      // 🔥 Create a new list (avoids modifying the original list in-place)
      final newRecipients = List<Recipient>.from(_recipients);

      // Move item instantly in the UI
      final movedRecipient = newRecipients.removeAt(event.oldIndex);
      newRecipients.insert(event.newIndex, movedRecipient);

      // Emit the updated state IMMEDIATELY ✅ (UI updates instantly)
      emit(RecipientLoaded(List.from(newRecipients)));

      // 🔥 Sync order in Firestore in the background (no UI delay)
      for (var i = 0; i < newRecipients.length; i++) {
        newRecipients[i] = newRecipients[i].copyWith(order: i);
        _recipientRepository.updateRecipientOrder(newRecipients[i].id, i); // No await
      }
    } catch (e) {
      emit(RecipientError('Failed to reorder recipients: $e'));
    } finally {
      _isReordering = false;
    }
  }

  Future<void> _onDeleteRecipient(
      DeleteRecipient event,
      Emitter<RecipientState> emit,
      ) async {
    try {
      await _recipientRepository.deleteRecipient(event.recipientId);
      final recipients = await _recipientRepository.getRecipients().first;
      emit(RecipientLoaded(recipients));
    } catch (e) {
      emit(RecipientError('Failed to delete recipient: $e'));
    }
  }
}