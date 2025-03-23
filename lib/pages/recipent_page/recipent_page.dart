import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/pages/recipent_page/recipent_list.dart';

import '../../bloc/recipents/recipent_bloc.dart';
import '../../bloc/recipents/recipent_event.dart';
import '../../data/repositories/recipent_repository.dart';

class RecipientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipients',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        backgroundColor: Colors.blueAccent,
        actions: [
        ],
      ),
      body: BlocProvider(
        create: (context) => RecipientBloc(RecipientRepository())..add(FetchRecipients()),
        child: RecipientList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: Icon(Icons.person_add),
        label: Text('Add Recipient'),
        onPressed: () {Navigator.pushNamed(context, '/page3');
          // TODO: Navigate to add recipient page
        },
      ),
    );
  }
}