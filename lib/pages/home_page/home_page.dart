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

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user.displayName ?? 'User'}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Recipients Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.people, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,),
                title: Text("Recipients"),
                subtitle: Text("Manage all your recipients"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/page1');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Contacts Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.contacts, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,),
                title: Text("Contacts"),
                subtitle: Text("View and add contacts"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/page3');
                },
              ),
            ),

            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 10),

            // Other Elements (Custom Widgets for Future Features)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(Icons.account_balance_wallet, "Budget", Colors.green, () {}),
                  _buildFeatureCard(Icons.trending_up, "Income", Colors.blue, () {}),
                  _buildFeatureCard(Icons.money_off, "Expenses", Colors.red, () {}),
                  _buildFeatureCard(Icons.bar_chart, "Reports", Colors.purple, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Function for Feature Cards
  Widget _buildFeatureCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}