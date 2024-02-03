import 'package:flutter/material.dart';
import 'package:hacker_news/app.dart';
import 'package:hacker_news/deps.dart';

Future<void> main() async {
  configureDeps();
  runApp(const App());
}
