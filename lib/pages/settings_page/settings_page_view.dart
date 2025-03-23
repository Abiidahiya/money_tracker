import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:money_tracker/pages/settings_page/settings_page_bloc.dart';
import 'package:money_tracker/pages/settings_page/settings_page_event.dart';
import 'package:money_tracker/pages/settings_page/settings_page_state.dart';

import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../bloc/theme/theme_state.dart';
import '../../uicomponents/buttons/logout_button/logout_button.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: BlocBuilder<ContainerVisibilityBloc, ContainerVisibilityState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, themeState) {
                        return SwitchListTile(
                          title: Text('Dark Mode'),
                          value: themeState.isDarkMode,
                          onChanged: (value) {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                        );
                      },
                    ),
                    // Toggle for Container 1
                    SwitchListTile(
                      title: Text('Show Container 1'),
                      value: state.containerVisibility[0],
                      onChanged: (value) {
                        context.read<ContainerVisibilityBloc>().add(
                          ToggleContainerVisibility(0, value),
                        );
                      },
                    ),
                    // Toggle for Container 2
                    SwitchListTile(
                      title: Text('Show Container 2'),
                      value: state.containerVisibility[1],
                      onChanged: (value) {
                        context.read<ContainerVisibilityBloc>().add(
                          ToggleContainerVisibility(1, value),
                        );
                      },
                    ),
                    // Toggle for Container 3
                    SwitchListTile(
                      title: Text('Show Container 3'),
                      value: state.containerVisibility[2],
                      onChanged: (value) {
                        context.read<ContainerVisibilityBloc>().add(
                          ToggleContainerVisibility(2, value),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: Text('Show Container 4'),
                      value: state.containerVisibility[3],
                      onChanged: (value) {
                        context.read<ContainerVisibilityBloc>().add(
                          ToggleContainerVisibility(3, value),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: Text('Show Container 5'),
                      value: state.containerVisibility[4],
                      onChanged: (value) {
                        context.read<ContainerVisibilityBloc>().add(
                          ToggleContainerVisibility(4, value),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LogoutButton(), // Logout button at the bottom
              ),
            ],
          );
        },
      ),
    );
  }
}
