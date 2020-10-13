import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactsApiClient {
  static const baseUrl = 'https://randomuser.me';
  ContactsApiClient();

  Future<List<dynamic>> getUsersContacts() async {
    print("fetching URL");
    final url = '$baseUrl/api/?results=20';
    final res = await http.get(url);
    final contactsJson = json.decode(res.body);
    final List<dynamic> contactsResultsJson = contactsJson['results'];
    return contactsResultsJson;
  }
}
