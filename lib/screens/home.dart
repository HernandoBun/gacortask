import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gacortask/widgets/bar%20graph/bar_graph.dart';
import 'package:gacortask/widgets/home_carousel.dart';
import 'package:gacortask/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.colorBlue4,
        elevation: 0,
        centerTitle: true,
        title: const Text(Constants.title),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      '${user!.email}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const CarouselHome(),
              const Text(
                Constants.taskText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                      horizontal: 42,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.colorGrey7,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            color: Constants.colorBlack,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Constants.taskText1,
                          style: TextStyle(color: Constants.colorBlack),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                      horizontal: 38,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.colorGrey7,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                            color: Constants.colorBlack,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Constants.taskText2,
                          style: TextStyle(color: Constants.colorBlack),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 6, right: 6, top: 10),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Constants.colorBlue3,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const BarGraph(),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Constants.colorWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.colorGrey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.calendar_today, color: Constants.colorBlue),
                    Text(
                      'Mengajar Frontend di kelas TI C',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '11-05',
                      style: TextStyle(color: Constants.colorGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signout()),
        child: const Icon(Icons.login_rounded),
      ),
    );
  }
}

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<double> userAktif = [10, 2, 5, 6, 12, 8, 15];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: MyBarGraph(userAktif: userAktif),
    );
  }
}

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   final user = FirebaseAuth.instance.currentUser;

//   signout() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('${user!.email}'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (() => signout()),
//         child: const Icon(Icons.login_rounded),
//       ),
//     );
//   }
// }