// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
import 'package:flutter/material.dart';

import 'view/home.dart';
import 'view/login.dart';
import 'view/profile.dart';
import 'view/add.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
        '/add': (BuildContext context) => const AddPage(),
        '/profile': (BuildContext context) => const Profile(),
        // '/detail': (BuildContext context) => const DetailPage(),
      },
      // TODO: Customize the theme (103)
      theme: ThemeData.light(useMaterial3: false),
    );
  }
}