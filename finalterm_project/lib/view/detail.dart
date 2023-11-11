import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorited = false; // 좋아요 상태를 추적하는 변수
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? productData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      productData =
          ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 생략...

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
        actions: [
          if (user?.uid == productData!['userId']) // 만약 현재 사용자가 게시물의 작성자인 경우
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/modify',
                  arguments: productData,
                );
              },
            ),
          if (user?.uid == productData!['userId']) // 만약 현재 사용자가 게시물의 작성자인 경우
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productData!.id)
                    .delete();
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        // for longer descriptions
        child: Column(
          children: <Widget>[
            Image.network(
              productData!['image'],
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productData!['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 6, 94, 194),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.thumb_up,
                          semanticLabel: 'like',
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          DocumentReference productRef = FirebaseFirestore
                              .instance
                              .collection('products')
                              .doc(productData!.id);
                          DocumentSnapshot productSnapshot =
                              await productRef.get();
                          List<dynamic> likedUsers =
                              productSnapshot.get('likedUid') ?? [];

                          if (likedUsers.contains(user!.uid)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('You can only do it once !!')),
                            );
                          } else {
                            likedUsers.add(user!.uid);
                            productRef.update({'likedUid': likedUsers});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('I LIKE IT !')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  Text(
                    '\$ ${productData!['price']}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 22, 114, 220),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  const Divider(
                    height: 1.0,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 15.0),

                  // Long description may need to scroll within the page.
                  SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .015,
                    ),
                    child: Text(
                      '${productData!['Description']}',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 22, 114, 220),
                      ),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
