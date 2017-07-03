import './home/home_page.dart';
import 'security/security.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new BlueRangeApp());
}

class BlueRangeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Bluerange",
      // home: new BlueRangeScreen(),
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => new LoginScreen(),
        '/home': (BuildContext context) => new HomeScreen(),
      },
    );
  }
}
