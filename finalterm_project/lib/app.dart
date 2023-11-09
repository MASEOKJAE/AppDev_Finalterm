// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
import 'package:flutter/material.dart';

import 'view/home.dart';
import 'view/login.dart';
// import 'view/signup.dart';
// import 'view/search.dart';
// import 'view/fvhotel.dart';
// import 'view/mypage.dart';
// import 'view/detail.dart';

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
        // '/signup': (BuildContext context) => const SignUpPage(),
        '/': (BuildContext context) => const HomePage(),
        // '/search': (BuildContext context) => const SearchPage(),
        // '/fvhotel': (BuildContext context) => const FvHotelPage(),
        // '/mypage': (BuildContext context) => const MyPage(),
        // '/detail': (BuildContext context) => const DetailPage(),
      },
      // TODO: Customize the theme (103)
      theme: ThemeData.light(useMaterial3: false),
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)