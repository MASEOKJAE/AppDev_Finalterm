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
  int _selectedIndex = 0;
  bool _isGridView = true; // true for GridView, false for ListView

  // TODO: Make a collection of cards (102)
  // List<Widget> _buildGridCards(BuildContext context) {
  //   // List<Hotel> hotels = HotelsRepository.loadHotels();

  //   if (hotels.isEmpty) {
  //     return const <Card>[];
  //   }

  //   // products 리스트의 각 요소에 대해 map() 함수를 실행
  //   return hotels.map((hotel) {
  //     // 각 product에 대해 아래의 코드 블록을 실행
  //     if (_isGridView) {
  //       // GridView card layout
  //       return Card(
  //         // clipBehavior 속성은 카드의 경계를 넘어가는 자식 위젯들이 어떻게 잘릴지 결정
  //         //  Clip.antiAlias는 경계를 부드럽게 만들어 줌
  //         clipBehavior: Clip.antiAlias,
  //         child: Column(
  //           // crossAxisAlignment 속성은 수직(열) 방향으로 어떻게 정렬할지 결정 (start -> 시작 위치에서 정렬)
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             // AspectRatio: 특정 비율(aspect ratio)을 유지하면서 그 안에 다른 위젯(여기서는 이미지)를 배치할 때 사용
  //             AspectRatio(
  //               aspectRatio: 18 / 11,
  //               child: Image.asset(
  //                 hotel.picture,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10),
  //                 child: Stack(
  //                   alignment: Alignment.bottomRight,
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         const Icon(
  //                           Icons.location_on,
  //                           size: 17,
  //                           color: Colors.blue,
  //                         ),
  //                         const SizedBox(width: 5),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   // Hotel star rating with outlined stars
  //                                   Row(
  //                                     children: List<Widget>.generate(
  //                                         hotel.star,
  //                                         (index) => const Icon(Icons.star,
  //                                             color: Colors.yellow,
  //                                             size: 15.0)),
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.start,
  //                                   ),
  //                                   const SizedBox(height: 2.0),

  //                                   Text(
  //                                     hotel.name,
  //                                     style: const TextStyle(
  //                                         fontSize: 13,
  //                                         fontWeight: FontWeight.bold),
  //                                     maxLines: 1,
  //                                   ),
  //                                   const SizedBox(height: 2.0),
  //                                   Text(
  //                                     hotel.location,
  //                                     style: const TextStyle(fontSize: 10),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pushNamed(
  //                           context,
  //                           '/detail',
  //                           arguments: hotel,
  //                         );
  //                       },
  //                       style: TextButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5, vertical: 2),
  //                         minimumSize: Size.zero,
  //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                       child: const Text('more'),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       // ListView card layout
  //       return Card(
  //         clipBehavior: Clip.antiAlias,
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
  //           child: Stack(
  //             children: [
  //               ListTile(
  //                 leading: AspectRatio(
  //                   aspectRatio: 1,
  //                   child: Image.asset(
  //                     hotel.picture,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 // title: Text(hotel.name),
  //                 subtitle: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Row(
  //                             children: List<Widget>.generate(
  //                               hotel.star,
  //                               (index) => const Icon(Icons.star,
  //                                   color: Colors.yellow, size: 15.0),
  //                             ),
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                           ),
  //                           const SizedBox(height: 2.0),
  //                           Text(
  //                             hotel.name,
  //                             style: const TextStyle(
  //                                 fontSize: 13, fontWeight: FontWeight.bold),
  //                             maxLines: 1,
  //                           ),
  //                           const SizedBox(height: 2.0),
  //                           Text(
  //                             hotel.location,
  //                             style: const TextStyle(fontSize: 10),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 80),
  //                   ],
  //                 ),
  //               ),
  //               Positioned(
  //                 // Positioned 위젯은 Stack 내에서 절대 위치를 지정할 수 있습니다.
  //                 right: 15, // 오른쪽으로부터의 거리
  //                 bottom: 2, // 아래로부터의 거리
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.pushNamed(context, '/detail', arguments: hotel);
  //                   },
  //                   style: ButtonStyle(
  //                     padding: MaterialStateProperty.all(
  //                         const EdgeInsets.symmetric(
  //                             horizontal: (5), vertical: (2))),
  //                     minimumSize: MaterialStateProperty.all(Size.zero),
  //                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                   ),
  //                   child: const Text('more', style: TextStyle(fontSize: 10)),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     }
  //   }).toList();
  // }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Add app bar (102)
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
          ), onPressed: () {
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
              // _launchURL();
            },
          )
        ],
      ),

      // TODO: Add a grid view (102)
      // GridView는 count() 생성자를 호출
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ToggleButtons(
                  children: const [
                    Icon(Icons.list),
                    Icon(Icons.grid_view),
                  ],
                  onPressed: (index) {
                    setState(() {
                      _isGridView = index == 1;
                    });
                  },
                  isSelected: [!_isGridView, _isGridView],
                ),
              ],
            ),
          ),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return _isGridView
                    ? GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: .8,
                        crossAxisSpacing: .5,
                        mainAxisSpacing: .5,
                        // children: _buildGridCards(context),
                      )
                    : ListView(padding: const EdgeInsets.all(16.0), children: [
                        Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                        ),
                        Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                        )
                      ]); //_buildGridCards(context));
              },
            ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: false,
    );
  }
}
