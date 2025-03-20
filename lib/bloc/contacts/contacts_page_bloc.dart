import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:money_tracker/bloc/contacts/contacts_page_event.dart';
import 'package:money_tracker/bloc/contacts/contacts_page_state.dart';


class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactState(contacts: [], isLoading: false)) {
    on<LoadContactsEvent>(_loadContacts);
    on<RefreshContactsEvent>(_refreshContacts);
  }

  Future<void> _loadContacts(LoadContactsEvent event, Emitter<ContactState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Request permission
    if (await Permission.contacts.request().isGranted) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final contactNames = contacts.map((c) => c.displayName).where((name) => name.isNotEmpty).toList();

      // Save contacts locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('saved_contacts', contactNames);

      emit(state.copyWith(contacts: contactNames, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _refreshContacts(RefreshContactsEvent event, Emitter<ContactState> emit) async {
    emit(state.copyWith(isLoading: true));

    final contacts = await FlutterContacts.getContacts(withProperties: true);
    final contactNames = contacts.map((c) => c.displayName).where((name) => name.isNotEmpty).toList();

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_contacts', contactNames);

    emit(state.copyWith(contacts: contactNames, isLoading: false));
  }
}