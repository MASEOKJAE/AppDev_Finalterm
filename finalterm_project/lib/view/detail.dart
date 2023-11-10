import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorited = false; // 좋아요 상태를 추적하는 변수
  User? user = FirebaseAuth.instance.currentUser;
  late DocumentSnapshot productData;

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
          if (user?.uid == productData['userId']) // 만약 현재 사용자가 게시물의 작성자인 경우
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                // 수정 로직을 여기에 추가하세요
              },
            ),
          if (user?.uid == productData['userId']) // 만약 현재 사용자가 게시물의 작성자인 경우
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productData.id)
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
            Stack(
              children: [
                Image.network(productData['image']),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 15.0, 35.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productData['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),

                  Text(
                    '\$ ${productData['price']}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 15.0),

                  const Divider(
                    height: 1.0,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 10.0),

                  // Long description may need to scroll within the page.
                  SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .015,
                    ),
                    child: Text('${productData['Description']}',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16)),
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
