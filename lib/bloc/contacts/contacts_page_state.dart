import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

class ContactState extends Equatable {
  final List<String> contacts;
  final bool isLoading;

  const ContactState({required this.contacts, this.isLoading = false});

  ContactState copyWith({List<String>? contacts, bool? isLoading}) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [contacts, isLoading];
}