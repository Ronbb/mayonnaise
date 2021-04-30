import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mayonnaise/App.dart';
import 'package:mayonnaise/utils/hive.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initX();

  runApp(App());
}
