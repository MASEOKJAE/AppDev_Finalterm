import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Rect getClip(Size size) {
  //   return const Rect.fromLTWH(0, 0, 200, 100);
  // }

  @override
  Widget build(BuildContext context) {
    Widget profile = Column(
      children: [
        /*2*/
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: const Text(
            'MA SEOK JAE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '21800239',
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ],
    );


    return Scaffold(
        appBar: AppBar(
          title: const Text('My Page'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ClipOval(
                  child: Container(
                    color: Colors.lightBlueAccent,
                    // child: Lottie.network(
                    //   'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                    //   width: 150,
                    //   height: 150,
                    // ),
                  ),
                ),
              ),
              profile,
              // Expanded(child: myfvhotel),
            ],
          ),
        ));
  }
}
