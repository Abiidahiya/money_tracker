import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/utils/constants/color.dart';
import 'package:money_tracker/pages/settings_page/settings_page_state.dart';
import 'package:money_tracker/pages/settings_page/settings_page_bloc.dart';
import 'package:money_tracker/utils/constants/font_size_constraints.dart';
import '../../bloc/contacts/contacts_page_event.dart';
import '../../uicomponents/container/custom_container.dart';
import '../contacts_page/contacts_page.dart';
import '../../bloc/contacts/contacts_page_bloc.dart';


class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/page_wallpaper_black.PNG',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: Colors.white, size: 30),
                      onPressed: () {
                        // Navigate to settings page directly
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ),
                  Text(
                    'Welcome, ${user.displayName ?? "User"}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 40),

                  BlocBuilder<ContainerVisibilityBloc, ContainerVisibilityState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (state.containerVisibility[0])
                            CustomContainer(
                              name: 'RECIPENTS',
                              containerColor: pastel_blue,
                              textStyle: TextStyle(fontWeight: FontWeight.bold ),
                              fontSize: 45,
                              fontColor: Colors.black45,
                              height: 200,
                              borderRadius: 15,
                              onTap: () {
                                // Navigate to page1 directly
                                Navigator.pushNamed(context, '/page1');
                              },
                            ),
                          SizedBox(height: 20),

                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (state.containerVisibility[1])
                                  CustomContainer(
                                    name: 'Container 2',
                                    containerColor: pastel_pink,
                                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                                    fontSize: 24,
                                    fontColor: Colors.black45,
                                    height: 160,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    borderRadius: 30,
                                    onTap: () {
                                      // Navigate to page2 directly
                                      Navigator.pushNamed(context, '/page2');
                                    },
                                  ),

                                SizedBox(width: 15),

                                if (state.containerVisibility[2])
                                  CustomContainer(
                                    name: 'Contacts',
                                    containerColor: pastel_purple,
                                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                                    fontSize: veryLargeFontSize,
                                    fontColor: Colors.black45,
                                    height: 160,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    borderRadius: 30,
                                    onTap: () {
                                      // Load contacts and navigate to contacts page directly
                                      BlocProvider.of<ContactBloc>(context).add(LoadContactsEvent());
                                      Navigator.pushNamed(context, '/page3');
                                    },
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          if (state.containerVisibility[3])
                            CustomContainer(
                              name: 'Container 4',
                              containerColor: pastel_green,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              fontSize: 24,
                              fontColor: Colors.black45,
                              height: 160,
                              borderRadius: 25,
                              onTap: () {
                                print("Container 4 tapped!");
                              },
                            ),
                          SizedBox(height: 20),

                          if (state.containerVisibility[4])
                            CustomContainer(
                              name: 'Container 5',
                              containerColor: pastel_orange,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              fontSize: 24,
                              fontColor: Colors.black45,
                              height: 120,
                              borderRadius: 45,
                              onTap: () {
                                print("Container 5 tapped!");
                                // Navigate to page5 directly
                                Navigator.pushNamed(context, '/page5');
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}