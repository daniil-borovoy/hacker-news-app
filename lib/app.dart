import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacker_news/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetCupertinoApp(
      home: HomeScreen(),
      title: "Hacker News",
      theme: CupertinoThemeData(
        primaryColor: Colors.deepOrange,
        barBackgroundColor: Color(0x00ff6600),
        brightness: Brightness.light,
      ),
    );
  }
}
