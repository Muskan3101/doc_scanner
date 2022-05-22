import 'package:flutter/material.dart';

import 'pages/home_page.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Doc Scanner",
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
      ),
      home: const HomePage(),
    );
  }
}
