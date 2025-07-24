import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Verifica que no esté ya inicializado
  if (Firebase.apps.isEmpty) {
    final apps = Firebase.apps;
    if (apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }



  runApp(const TallerApp());
}
  