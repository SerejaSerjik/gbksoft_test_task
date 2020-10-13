import 'package:flutter/material.dart';
import 'package:gbksoft_test_task_1/pages/contacts_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ContactsPage(),
    );
  }
}
