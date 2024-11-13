import 'package:flutter/material.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to Profile Screen
              Navigator.pushNamed(context, '/profile');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('My Pick Ups'),
            onTap: () {
              // Navigate to My Pick Ups Screen
              Navigator.pushNamed(context, '/pickUps');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('My Transactions'),
            onTap: () {
              // Navigate to My Transactions Screen
              Navigator.pushNamed(context, '/transactions');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('My Wallet'),
            onTap: () {
              // Navigate to My Wallet Screen
              Navigator.pushNamed(context, '/wallet');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.phone_book),
            title: const Text('Address Book'),
            onTap: () {
              // Navigate to Address Book Screen
              Navigator.pushNamed(context, '/addressBook');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to Settings Screen
              Navigator.pushNamed(context, '/settings');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to Help & Support Screen
              Navigator.pushNamed(context, '/help');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout
              // For example, clear user session and navigate to login screen
              Navigator.pushNamed(context, '/login');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
