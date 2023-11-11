import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'Asc';

  Widget _buildGridCards(BuildContext context) {
    final isAscending = dropdownValue != 'Desc';

    Iterable<Widget> a;

    return Consumer<ProductRepository>(
      builder: (context, provider, child) {
        return GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 행에 두 개의 항목 표시
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: provider.getSortedList(isAscending).map((p) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18 / 11,
                    child: Image.network(
                      p.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        'Price: ${p.price}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: p,
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
          }).toList(),
        );
      }
    );


  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _firestore
  //         .collection('products')
  //         .orderBy('price', descending: !isAscending)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return const CircularProgressIndicator();

  //       final List<DocumentSnapshot> documents = snapshot.data!.docs;

  //       return GridView.builder(
  //         itemCount: documents.length,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2, // 한 행에 두 개의 항목 표시
  //           crossAxisSpacing: 10,
  //           mainAxisSpacing: 10,
  //         ),
  //         itemBuilder: (context, index) {
  //           return Card(
  //             clipBehavior: Clip.antiAlias,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 AspectRatio(
  //                   aspectRatio: 18 / 11,
  //                   child: Image.network(
  //                     documents[index]['image'],
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(5),
  //                     child: Stack(
  //                       alignment: Alignment.bottomRight,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(15.0),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Expanded(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       documents[index]['name'],
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           fontWeight: FontWeight.bold),
  //                                       maxLines: 1,
  //                                     ),
  //                                     const SizedBox(height: 2.0),
  //                                     Text(
  //                                       'Price: ${documents[index]['price']}',
  //                                       style: const TextStyle(fontSize: 10),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         TextButton(
  //                           onPressed: () {
  //                             Navigator.pushNamed(
  //                               context,
  //                               '/detail',
  //                               arguments: documents[index],
  //                             );
  //                           },
  //                           style: TextButton.styleFrom(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 5, vertical: 2),
  //                             minimumSize: Size.zero,
  //                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                           ),
  //                           child: const Text('more'),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
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
          const SizedBox(
            height: 30,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            items: <String>['Asc', 'Desc'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(
                  () {
                    dropdownValue = newValue;
                  },
                );
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(child: _buildGridCards(context)),
        ],
      ),
    );
  }
}
