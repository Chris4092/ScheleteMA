import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schelet_v1/repo/repo.dart';
import 'package:schelet_v1/section1.dart';
import 'package:schelet_v1/section2.dart';
import 'package:schelet_v1/section3.dart';
import 'package:schelet_v1/section4.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyHomePage extends StatefulWidget {


  const MyHomePage({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<MyHomePage> createState() => _MyHomePageState(repo);
}

class _MyHomePageState extends State<MyHomePage> {

  final Repo repo;

  _MyHomePageState(this.repo);

  final driverController = TextEditingController();

  String? driverName = '';

  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //here is the async code, you can execute any async code here
      driverName = prefs.getString('driver');
      driverName ??= '';
      driverController.text = driverName!;
    });

    super.initState();
  }

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
            ElevatedButton(onPressed:() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              //here is the async code, you can execute any async code here
              if(driverController.text=='') {
                Fluttertoast.showToast(msg: 'nu fi cocalar si baga nume');
              }
              else {
                prefs.setString('driver', driverController.text);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Section4(repo: repo,)));
              }
            },child: const Text('Section 4 da sper sa nu'),),
            TextField(
              controller: driverController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'name'),
            ),
          ],
        ),
      ),
    );
  }
}
