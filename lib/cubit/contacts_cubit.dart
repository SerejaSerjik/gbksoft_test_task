import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gbksoft_test_task_1/repository/contacts_repository.dart';
import 'package:meta/meta.dart';
import '../models/contacts.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepository contactsRepository;

  ContactsCubit({@required this.contactsRepository})
      : assert(contactsRepository != null),
        super(ContactsInitial());

  Future<void> getContactsList() async {
    try {
      emit(ContactsLoading());
      List<Contacts> loadedContacts =
          await contactsRepository.getContactsFromApi();
      await contactsRepository.insertContactsToDB(loadedContacts);
      final dbContacts = await contactsRepository.getContactsFromDB();
      emit(ContactsLoaded(loadedContacts: dbContacts));
    } catch (e) {
      emit(ContactsError());
      Timer(Duration(seconds: 2), () => emit(ContactsEmpty()));
    }
  }

  Future<void> deleteContactFromDB(Contacts contact) async {
    final newDB = await contactsRepository.deleteContactFromDB(contact);
    emit(ContactsLoaded(loadedContacts: newDB));
  }

  Future<void> dropDatabase() async {
    emit(ContactsLoading());
    await contactsRepository.dropDatabase();
    emit(ContactsLoaded(loadedContacts: []));
  }

  Future<void> updateUsersContacts(
      String id, String newFirstName, String newLastName) async {
    await contactsRepository.updateUserData(id, newFirstName, newLastName);
    final dbContacts = await contactsRepository.getContactsFromDB();
    emit(ContactsLoaded(loadedContacts: dbContacts));
  }
}
