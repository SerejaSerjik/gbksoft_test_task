import 'package:gbksoft_test_task_1/database/database_provider.dart';

class Contacts {
  String id;
  String firstName;
  String lastName;
  String photoUrl;

  Contacts({
    this.id,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseProvider.COLUMN_ID: id,
      DatabaseProvider.COLUMN_FIRST_NAME: firstName,
      DatabaseProvider.COLUMN_LAST_NAME: lastName,
      DatabaseProvider.COLUMN_PHOTO_URL: photoUrl,
    };

    return map;
  }

  Contacts.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    firstName = map[DatabaseProvider.COLUMN_FIRST_NAME];
    lastName = map[DatabaseProvider.COLUMN_LAST_NAME];
    photoUrl = map[DatabaseProvider.COLUMN_PHOTO_URL];
  }
}
