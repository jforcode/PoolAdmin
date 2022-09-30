import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';
import 'package:pool_admin/util.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    setup();
  }

  void setup() async {
    bool done = await Repo.setup();
    if (!done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during setup")),
      );

      executePostTimer(() {
        exit(0);
      });
      return;
    }

    executePostTimer(() {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(Util.routeHome);
    });
  }

  void executePostTimer(VoidCallback callback) {
    Timer(const Duration(milliseconds: 3000), () {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Image(
          image: AssetImage('assets/images/cover.webp'),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Colors.white,
            ),
            child: Text(
              "POOL ADMIN",
            ),
          ),
        ),
      ],
    );
  }
}
