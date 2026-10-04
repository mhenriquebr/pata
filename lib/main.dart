import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pata/app/app.dart';
import 'package:pata/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PataApp());
}
