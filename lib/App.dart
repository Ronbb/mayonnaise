import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mayonnaise/pages/Instance/instance.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mayonnaise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(title: 'WebSocket'),
      home: InstancePage(),
    );
  }
}
