import 'package:flutter/material.dart';
import 'package:gbksoft_test_task_1/pages/contacts_page.dart';

void main() {
  runApp(MyApp());
}

/*При первой загрузке к сущесвующей БД добавляется +20 новых юзеров. Мог реализовать и удаление "старой" базы при инициализации новой, но решил оставить так.
Для тогоЮ что бы база не стала слишком большой добавил иконку в тайтл для очистки текущей базы.
Постарался сделать "типа клин архитектуру", хотя, конечно, ей далеко до идеала.
Репозиторий работает с апи и бд, а уже он прокидывается в кубит. */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ContactsPage(),
    );
  }
}
