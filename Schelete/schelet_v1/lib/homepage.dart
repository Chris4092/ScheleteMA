import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';
import 'package:schelet_v1/section1.dart';
import 'package:schelet_v1/section2.dart';
import 'package:schelet_v1/section3.dart';
import 'package:schelet_v1/section4.dart';


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<MyHomePage> createState() => _MyHomePageState(repo);
}

class _MyHomePageState extends State<MyHomePage> {

  final Repo repo;

  _MyHomePageState(this.repo);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Section1(repo: repo,) ));
              }
              ,child: const Text('Section 1'),),
            ElevatedButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Section2(repo: repo,) ));
            },child: const Text('Section 2'),),
            ElevatedButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Section3(repo: repo,) ));
            },child: const Text('Section 3'),),
            ElevatedButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Section4(repo: repo,) ));
            },child: const Text('Section 4 da sper sa nu'),),
          ],
        ),
      ),
    );
  }
}
