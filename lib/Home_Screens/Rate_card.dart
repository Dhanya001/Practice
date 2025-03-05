import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FinanceDashboard(),
    );
  }
}

class FinanceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              Tab(text: "ACCOUNTS"),
              Tab(text: "WALLET NOW"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AccountsPage(),
            Center(child: Text("Wallet Page")),
          ],
        ),
      ),
    );
  }
}

class AccountsPage extends StatelessWidget {
  final List<Map<String, dynamic>> accounts = [
    {"name": "CASH", "amount": 750.00, "color": Colors.blue},
    {"name": "BANK", "amount": 3469.50, "color": Colors.purple},
    {"name": "SAVINGS", "amount": 6220.00, "color": Colors.green},
    {"name": "STOCKS", "amount": 18322.43, "color": Colors.orange},
    {"name": "PAY PAL", "amount": 1300.00, "color": Colors.blue[900]},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: accounts.map((account) {
              return Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: account["color"],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      account["name"],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "\$${account["amount"].toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Expenses structure"),
                    subtitle: Text("LAST 30 DAYS"),
                    trailing: Text("+88%", style: TextStyle(color: Colors.red)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(value: 40, color: Colors.orange),
                            PieChartSectionData(value: 30, color: Colors.purple),
                            PieChartSectionData(value: 20, color: Colors.blue),
                            PieChartSectionData(value: 10, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
