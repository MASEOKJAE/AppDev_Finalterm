import 'package:finalterm_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';     // new
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                 

import 'app_state.dart';                                 
import '/app.dart';

void main() async {
  // 이 부분 추가
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const ShrineApp()),
  ));
}