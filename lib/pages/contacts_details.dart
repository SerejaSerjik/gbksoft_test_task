import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/contacts_repository.dart';
import '../cubit/contacts_cubit.dart';
import '../models/contacts.dart';

class ContactsDetails extends StatefulWidget {
  final Contacts userContacts;
  final ContactsRepository contactsRepository;
  ContactsDetails({this.userContacts, this.contactsRepository})
      : assert(userContacts != null);

  @override
  _ContactsDetailsState createState() => _ContactsDetailsState();
}

class _ContactsDetailsState extends State<ContactsDetails> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.userContacts.firstName;
    lastNameController.text = widget.userContacts.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Contacts Editing"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: firstNameController,
          ),
          TextFormField(
            controller: lastNameController,
          ),
          //чет не мог добраться до блока никак в этом контексте, пришлось обернуть в провайдер и билдер, что бы заработало
          RaisedButton(
            onPressed: () {
              BlocProvider.of<ContactsCubit>(context).updateUsersContacts(
                  widget.userContacts.id,
                  firstNameController.text,
                  lastNameController.text);
            },
            child: Text("Save user data"),
          )
        ],
      ),
    );
  }
}
