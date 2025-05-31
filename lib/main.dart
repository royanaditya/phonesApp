// main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/create_page.dart';
import 'pages/edit_page.dart';
import 'pages/detail_page.dart';
import 'models/phones.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Catalog',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        CreatePage.routeName: (context) => CreatePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == DetailPage.routeName) {
          final phone = settings.arguments as Phone;
          return MaterialPageRoute(
            builder: (context) => DetailPage(phone: phone),
          );
        }

        if (settings.name == EditPage.routeName) {
          final phone = settings.arguments as Phone;
          return MaterialPageRoute(
            builder: (context) => EditPage(phone: phone),
          );
        }

        return null;
      },
    );
  }
}