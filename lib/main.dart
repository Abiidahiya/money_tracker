import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication/auth_bloc.dart';
import 'package:money_tracker/bloc/contacts/contacts_page_bloc.dart';
import 'package:money_tracker/pages/container_1_page/container_1_page.dart';
import 'package:money_tracker/pages/container_2_page/container_2_page_view.dart';
import 'package:money_tracker/pages/contacts_page/contacts_page.dart';
import 'package:money_tracker/pages/container_5_page/container_5_page.dart';
import 'package:money_tracker/pages/home_page/home_page.dart';
import 'package:money_tracker/pages/login_page.dart';
import 'package:money_tracker/pages/recipent_page/recipent_page.dart';
import 'package:money_tracker/pages/settings_page/settings_page_bloc.dart';
import 'package:money_tracker/pages/settings_page/settings_page_view.dart';
import 'bloc/authentication/auth_event.dart';
import 'bloc/authentication/auth_state.dart';
import 'bloc/recipents/recipent_bloc.dart';
import 'data/repositories/recipent_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiRepositoryProvider(
      providers: [
      RepositoryProvider(create: (context) => RecipientRepository()),],
      child: MyApp(),),);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckAuthStatus())),
        BlocProvider(create: (context) => ContainerVisibilityBloc()),
        BlocProvider(create: (context) => ContactBloc()),
        BlocProvider(create: (context) => RecipientBloc(
         context.read<RecipientRepository>(),)

    )],
      child: MaterialApp(
        title: 'Flutter Firebase Login',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            print("Current state: $state"); // Debug log
            if (state is Authenticated) {
              return HomePage(user: state.user);
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/settings': (context) => SettingsPage(),
          '/page1': (context) => RecipientPage(),
          '/page2': (context) => Container2Page(),
          '/page3': (context) => ContactsPage(),
          '/page5': (context) => Container5Page(),
        },
      ),
    );
  }
}