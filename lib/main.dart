import 'package:flutter/material.dart';
import 'package:pool_admin/add_pending_view.dart';
import 'package:pool_admin/game_history_view.dart';
import 'package:pool_admin/home_view.dart';
import 'package:pool_admin/settings_view.dart';
import 'package:pool_admin/splash_view.dart';
import 'package:pool_admin/util.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pool Admin',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      initialRoute: Util.routeSplash,
      debugShowCheckedModeBanner: false,
      routes: {
        Util.routeSplash: (context) => const SplashView(),
        Util.routeHome: (context) => const HomeView(),
        Util.routeHistory: (context) => const GameHistoryView(),
        Util.routeSettings: (context) => const SettingsView(),
        Util.routeNewPending: (context) => const AddPendingView(),
      },
    );
  }
}
