import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbksoft_test_task_1/api/contacts_api_client.dart';
import 'package:gbksoft_test_task_1/cubit/contacts_cubit.dart';
import 'package:gbksoft_test_task_1/pages/contacts_details.dart';
import 'package:gbksoft_test_task_1/repository/contacts_repository.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final ContactsRepository contactsRepository =
        ContactsRepository(contactsApiClient: ContactsApiClient());

    return BlocProvider(
      create: (context) {
        return ContactsCubit(contactsRepository: contactsRepository)
          ..getContactsList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ContactsCubit, ContactsState>(
            builder: (context, state) {
              if (state is ContactsLoaded) {
                return Text(
                  "Contacts in db: ${state.loadedContacts.length}",
                );
              }
              return Text("Contacts");
            },
          ),
          actions: [
            //не хотел оборачивать весь Scaffold в BlockBuilder, дабы не повторять код шапки
            //но пришлось обернуть в билдер экшн кнопку, иначе иконка не видела в контексте кубит((
            BlocBuilder<ContactsCubit, ContactsState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () {
                          context.bloc<ContactsCubit>().dropDatabase();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                );
              },
            )
          ],
        ),
        body: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state is ContactsInitial) {
              return Center(child: Text("HELLO"));
            }
            if (state is ContactsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ContactsLoaded) {
              return ListView.builder(
                itemCount: state.loadedContacts.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(color: Colors.red),
                    key: Key(state.loadedContacts[index].id),
                    onDismissed: (direction) {
                      context
                          .bloc<ContactsCubit>()
                          .deleteContactFromDB(state.loadedContacts[index]);
                      state.loadedContacts.removeAt(index);
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("Deleted!")));
                    },
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return BlocProvider<ContactsCubit>.value(
                                value: BlocProvider.of<ContactsCubit>(context),
                                child: ContactsDetails(
                                  userContacts: state.loadedContacts[index],
                                  contactsRepository: contactsRepository,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      title: Row(
                        children: [
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    state.loadedContacts[index].photoUrl),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(state.loadedContacts[index].firstName),
                          SizedBox(
                            width: 15,
                          ),
                          Text(state.loadedContacts[index].lastName),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is ContactsError) {
              return Center(
                child: Text("asdasd"),
              );
            }
            if (state is ContactsEmpty) {
              return Center(child: Text("sdfsdfd"));
            }
            return Center(
              child: Text("Unidentified error"),
            );
          },
        ),
      ),
    );
  }
}
