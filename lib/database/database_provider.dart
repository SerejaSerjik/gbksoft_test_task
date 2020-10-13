import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contacts.dart';

class DatabaseProvider {
  static const String TABLE_CONTACTS = "contacts";
  static const String COLUMN_ID = "id";
  static const String COLUMN_FIRST_NAME = "first_name";
  static const String COLUMN_LAST_NAME = "last_name";
  static const String COLUMN_PHOTO_URL = "photo_url";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    print("creating db...");
    _database = await createDatabase();

    return _database;
  }

  Future<void> dropDatabase() async {
    String dbPath = await getDatabasesPath();
    return await deleteDatabase(join(dbPath, 'contacts.db'));
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    print("inside createDatabase");
    return await openDatabase(
      join(dbPath, 'contacts.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating contacts table");

        await database.execute("CREATE TABLE $TABLE_CONTACTS("
            "$COLUMN_ID TEXT PRIMARY KEY,"
            "$COLUMN_FIRST_NAME TEXT,"
            "$COLUMN_LAST_NAME TEXT,"
            "$COLUMN_PHOTO_URL TEXT)");
      },
    );
  }

  Future<List<Contacts>> getUsersContacts() async {
    final db = await database;

    final contacts = await db.query(TABLE_CONTACTS, columns: [
      COLUMN_ID,
      COLUMN_FIRST_NAME,
      COLUMN_LAST_NAME,
      COLUMN_PHOTO_URL,
    ]);

    List<Contacts> usersContacts = List<Contacts>();

    contacts.forEach((currentContact) {
      Contacts contact = Contacts.fromMap(currentContact);

      usersContacts.add(contact);
    });

    return usersContacts;
  }

  Future<void> insert(Contacts contact) async {
    final db = await database;

    await db.insert(TABLE_CONTACTS, contact.toMap());
  }

  Future<void> delete(Contacts contact) async {
    final db = await database;

    await db.rawDelete(
        "DELETE FROM $TABLE_CONTACTS WHERE $COLUMN_ID = ?", ['${contact.id}']);
  }

  Future<void> update(
      String id, String newFirstName, String newLastName) async {
    final db = await database;

    await db.rawUpdate(
        "UPDATE $TABLE_CONTACTS SET $COLUMN_FIRST_NAME = ?, $COLUMN_LAST_NAME = ? WHERE $COLUMN_ID = ?",
        ['$newFirstName', '$newLastName', '$id']);
  }
}
