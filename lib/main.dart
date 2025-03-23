import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_event.dart';
import 'bloc/theme/theme_state.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'data/repositories/recipent_repository.dart';
import 'data/repositories/transaction_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthStatus()),
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final String userId = state.user.uid;
          final FirebaseFirestore firestore = FirebaseFirestore.instance;

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (context) => RecipientRepository()),
              RepositoryProvider(create: (context) => TransactionRepository(firestore: firestore, userId: userId)),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => ContainerVisibilityBloc()),
                BlocProvider(create: (context) => ContactBloc()),
                BlocProvider(create: (context) => RecipientBloc(context.read<RecipientRepository>())),
                BlocProvider(create: (context) => TransactionBloc(firestore: firestore, userId: userId)),
                BlocProvider(create: (context) => ThemeBloc()..add(LoadThemeEvent())),
              ],
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp(
                    title: 'Flutter Firebase Login',
                    debugShowCheckedModeBanner: false,
                    theme: themeState.themeData,
                    home: HomePage(user: state.user),
                    routes: {
                      '/settings': (context) => SettingsPage(),
                      '/page1': (context) => RecipientPage(),
                      '/page2': (context) => Container2Page(),
                      '/page3': (context) => ContactsPage(),
                      '/page5': (context) => Container5Page(),
                    },
                  );
                },
              ),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Flutter Firebase Login',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: LoginPage(),
          );
        }
      },
    );
  }
}
