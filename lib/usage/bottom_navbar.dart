// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// class BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _page = 0;
//   GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: CurvedNavigationBar(
//           key: _bottomNavigationKey,
//           index: 0,
//           height: 65.0,
//           items: <Widget>[
//             const Icon(Icons.add, size: 33,color: Colors.blue,),
//             const Icon(Icons.list, size: 33,color: Colors.blue,),
//             const Icon(Icons.contact_mail, size: 33,color: Colors.blue,),
//             const Icon(Icons.call, size: 33,color: Colors.blue,),
//             const Icon(Icons.perm_identity, size: 33,color: Colors.blue,),
//           ],
//           color: Colors.white,
//           buttonBackgroundColor: Colors.white,
//           backgroundColor: Colors.blue,
//           animationCurve: Curves.easeInOut,
//           animationDuration: const Duration(milliseconds: 600),
//           onTap: (index) {
//             setState(() {
//               _page = index;
//               print(_page);
//             });
//           },
//           letIndexChange: (index) => true,
//         ),
//         body: Container(
//           color: Colors.blueAccent,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                if(_page==0)
//                  const Icon(Icons.add,size: 130,color: Colors.white,),
//                if (_page==1)
//                  const Icon(Icons.list,size: 130,color: Colors.black,), 
//                if (_page==2)
//                  const Icon(Icons.contact_mail,size: 130,color: Colors.white,), 
                
//                if (_page==3)
//                  const Icon(Icons.call,size: 130,color: Colors.black,), 
//                if (_page==4)
//                  const Icon(Icons.perm_identity,size: 130,color: Colors.white,),        
//                  Text(_page.toString(), textScaleFactor: 5),
//                 ElevatedButton(
//                   child: const Text('Go To Page of index 0'),
//                   onPressed: () {
//                     final CurvedNavigationBarState? navBarState =
//                         _bottomNavigationKey.currentState;
//                     navBarState?.setPage(0);
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//   }
// }