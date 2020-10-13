import 'package:flutter/cupertino.dart';
import 'package:gbksoft_test_task_1/api/contacts_api_client.dart';

import '../database/database_provider.dart';
import '../models/contacts.dart';

class ContactsRepository {
  final ContactsApiClient contactsApiClient;

  ContactsRepository({@required this.contactsApiClient})
      : assert(contactsApiClient != null);

  Future<List<Contacts>> getContactsFromApi() async {
    final List<dynamic> fetchedJson =
        await contactsApiClient.getUsersContacts();
    final List<Contacts> fetchedContactsFromJson = [];
    for (final jsonContacts in fetchedJson) {
      fetchedContactsFromJson.add(Contacts(
        id: jsonContacts['login']['uuid'],
        firstName: jsonContacts['name']['first'],
        lastName: jsonContacts['name']['last'],
        photoUrl: jsonContacts['picture']['thumbnail'],
      ));
    }
    return fetchedContactsFromJson;
  }

  Future<List<Contacts>> getContactsFromDB() async {
    return await DatabaseProvider.db.getUsersContacts();
  }

  Future<List<Contacts>> insertContactsToDB(List<Contacts> contacts) async {
    for (final contact in contacts) {
      await DatabaseProvider.db.insert(contact);
    }
    return await DatabaseProvider.db.getUsersContacts();
  }

  Future<List<Contacts>> deleteContactFromDB(Contacts contact) async {
    await DatabaseProvider.db.delete(contact);
    return await DatabaseProvider.db.getUsersContacts();
  }

  Future<void> dropDatabase() async {
    await DatabaseProvider.db.dropDatabase();
  }

  Future<void> updateUserData(
      String id, String newFirstName, String newLastName) async {
    await DatabaseProvider.db.update(id, newFirstName, newLastName);
  }
}
