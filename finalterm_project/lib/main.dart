import 'package:finalterm_project/firebase_options.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';     // new
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                 

import '/app.dart';

void main() async {
  // 이 부분 추가
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductRepository()),
      ChangeNotifierProvider(create: (_) => UserRepository()),
    ],
    builder: ((context, child) => const ShrineApp()),
  ));
}