import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'container_2_page_bloc.dart';
import 'container_2_page_event.dart';
import 'container_2_page_state.dart';

class Container2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container 2 Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(child: Text('This is Container 2 Page')),
    );
  }
}