import 'package:flutter/material.dart';
import 'package:pool_admin/pending_amount_view.dart';

import 'booking_view.dart';
import 'calculate_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  List<Widget> homePages = [
    const BookingView(),
    const CalculateView(),
    const PendingAmountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pool Admin")),
      drawer: Drawer(
        width: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Developed By"),
            Text("Jeevan MB"),
            Text("jforcode@gmail.com"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calculate"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: "Pending"),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: homePages[selectedIndex],
    );
  }
}
