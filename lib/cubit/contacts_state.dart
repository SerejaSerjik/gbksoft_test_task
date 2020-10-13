part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsEmpty extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Contacts> loadedContacts;

  ContactsLoaded({@required this.loadedContacts})
      : assert(loadedContacts != null);
}

class ContactsError extends ContactsState {}
