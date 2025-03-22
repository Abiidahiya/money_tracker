import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/recipents/recipent_event.dart';
import 'package:money_tracker/bloc/recipents/recipent_state.dart';

import '../../data/models/recipent_model.dart';
import '../../data/repositories/recipent_repository.dart';

class RecipientBloc extends Bloc<RecipientEvent, RecipientState> {
  final RecipientRepository _recipientRepository;
  List<Recipient> _recipients = [];
  bool _isReordering = false;

  RecipientBloc(this._recipientRepository) : super(RecipientInitial()) {
    on<FetchRecipients>(_onFetchRecipients);
    on<ReorderRecipients>(_onReorderRecipients);
    on<DeleteRecipient>(_onDeleteRecipient);
  }

  Future<void> _onFetchRecipients(
      FetchRecipients event, Emitter<RecipientState> emit) async {
    emit(RecipientLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(RecipientError('User not authenticated'));
        return;
      }

      await for (final recipients in _recipientRepository.getRecipients()) {
        if (!_isReordering || event.forceUpdate) {
          _recipients = recipients;
          emit(recipients.isEmpty
              ? RecipientError('No recipients found.')
              : RecipientLoaded(recipients));
        }
      }
    } catch (e) {
      emit(RecipientError('Error fetching recipients: $e'));
    }
  }

  Future<void> _onReorderRecipients(
      ReorderRecipients event, Emitter<RecipientState> emit) async {
    if (event.oldIndex == event.newIndex) return;

    _isReordering = true;
    try {
      final newRecipients = List<Recipient>.from(_recipients);
      final movedRecipient = newRecipients.removeAt(event.oldIndex);
      newRecipients.insert(event.newIndex, movedRecipient);
      emit(RecipientLoaded(List.from(newRecipients)));

      for (var i = 0; i < newRecipients.length; i++) {
        newRecipients[i] = newRecipients[i].copyWith(order: i);
        await _recipientRepository.updateRecipientOrder(newRecipients[i].id, i);
      }
    } catch (e) {
      emit(RecipientError('Failed to reorder recipients: $e'));
    } finally {
      _isReordering = false;
    }
  }

  Future<void> _onDeleteRecipient(
      DeleteRecipient event, Emitter<RecipientState> emit) async {
    try {
      await _recipientRepository.deleteRecipient(event.recipientId);
      add(FetchRecipients(forceUpdate: true));
    } catch (e) {
      emit(RecipientError('Failed to delete recipient: $e'));
    }
  }
}
