import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new

import '../app_state.dart'; // new
import '../src/authentication.dart';
import 'package:flutter/material.dart';

// import '../model/hotel.dart';
// import '../model/hotels_repository.dart';
// import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isGridView = true; // true for GridView, false for ListView

  StreamBuilder<QuerySnapshot> _buildGridCards(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return GridView.builder(
          itemCount: documents.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18 / 11,
                    child: Image.network(
                      documents[index]['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            documents[index]['name'],
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Price: ${documents[index]['price']}',
                            style: const TextStyle(fontSize: 10),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            documents[index]['Description'],
                            style: const TextStyle(fontSize: 10),
                          ),
                          SizedBox(height: 2.0),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: documents[index],
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('more'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle,
            semanticLabel: 'profile',
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'plus',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          DropdownButton<String>(
            items: <String>['A', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 30,),
          Expanded(child: _buildGridCards(context)),
        ],
      ),
    );
  }
}
