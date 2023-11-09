import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              Container(
                width: 100,
                height: 100,
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image:
                //   ),
                //     shape: BoxShape.rectangle,
                //   ),
              ),
            const SizedBox(height: 10),
            Text(
              '<${user?.uid}>',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            const Divider(
              height: 1.0,
              thickness: 1,
              color: Colors.white,
            ),

            const SizedBox(height: 30),
            Text(
              user?.email ?? 'Anonymous',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'MA SEOK JAE',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'I promise to take the test honestly before GOD',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
