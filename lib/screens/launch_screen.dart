import 'package:events/screens/event_screen.dart';
import 'package:events/screens/login_screens.dart';
import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  Authentication auth = Authentication();
  MaterialPageRoute? route;

  @override
  void initState() {
    auth.getUser().then((user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EventScreen()),
            (Route route) => false);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth.getUser().then((user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const EventScreen()),
          (Route route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route route) => false,
        );
      }
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
        ),
      ),
    );
  }
}
