import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';

import 'deletepage.dart';

class Section2 extends StatefulWidget {

  const Section2({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Section2> createState() => _Section2State(repo);
}

class _Section2State extends State<Section2> {

  final Repo repo;

  _Section2State(this.repo);

  late Future<List<String>> entityLoadFunction;

  Future<List<String>> initialiseColorsToLoad() async {
    List<String> colors = await repo.getColors();

    return colors;
  }

  void initState() {
    setState(() {
      entityLoadFunction = initialiseColorsToLoad();
    });
  }

  FutureBuilder<List<String>> getAsyncEntities(){
    return FutureBuilder<List<String>>(builder: (BuildContext ctxt, AsyncSnapshot<List<String>> snapshot) {
      List<Widget> children;
      if(snapshot.hasData){
        return getEntityListView(snapshot.data!);
      }
      else if(snapshot.hasError){
        children = <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 100,
          ),
          Padding(padding:
          const EdgeInsets.only(top:16),
              child: Text("Error: ${snapshot.error}")
          )
        ];
      }
      else{
        children = <Widget>[
          const SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          ),
          const Padding(padding:
          EdgeInsets.only(top: 16),
              child: Text("Waiting...")
          )
        ];
      }
      return Center(child: Column(children: children, mainAxisAlignment : MainAxisAlignment.center,));
    },
      future: entityLoadFunction,
    );
  }

  ListView getEntityListView(List<String> entities){
    return ListView.builder(
        itemCount: entities.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap:() =>
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
            DeletePage(repo: repo, color: entities[index])
            ))
            },
            child: Card(
              color: Colors.lightBlue,
              child: Column(
                children: [
                  ListTile(title: Text(entities[index]))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 2'),
      ),
      body: getAsyncEntities(),
    );
  }
}