import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';
import 'package:schelet_v1/top10driverspage.dart';
import 'package:schelet_v1/top10vehiclespage.dart';
import 'package:schelet_v1/top5vehiclespage.dart';

class Section3 extends StatefulWidget {

  const Section3({Key? key, required this.repo}) : super(key: key);

  final Repo repo;

  @override
  State<Section3> createState() => _Section3State(repo);
}

class _Section3State extends State<Section3> {

  final Repo repo;

  _Section3State(this.repo);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child:
            Column(
              children: <Widget>[
                ElevatedButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          Top10VehiclesPage(repo: repo,)));
                }, child: const Text('top 10 vehicles')),
                ElevatedButton(onPressed:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          Top10DriversPage(repo: repo,)));
                }, child: const Text('top 10 drivers')),
                ElevatedButton(
                    onPressed:() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Top5VehiclesPage(repo: repo,)));
                    }, child: const Text('top 5 biggest vehicles')),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }

}