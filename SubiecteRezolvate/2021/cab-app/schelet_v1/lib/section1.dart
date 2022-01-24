import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schelet_v1/addpage.dart';
import 'package:schelet_v1/repo/repo.dart';

import 'domain/entity.dart';

class Section1 extends StatefulWidget {

  const Section1({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Section1> createState() => _Section1State(repo);
}

class _Section1State extends State<Section1> {

  final Repo repo;

  Vehicle? entityToAdd;

  late Future<List<Vehicle>> entityLoadFunction;

  Future<List<Vehicle>> initialiseEntitiesToLoad() async {
    List<Vehicle> entities = await repo.getAll();
    if(entityToAdd!=null) {
        entities.add(entityToAdd!);
    }
    return entities;
  }

  void initStateAfterAdd(Vehicle entity) {
    entityToAdd = entity;
    initState();
    entityToAdd = null;
  }

  void initState() {
    setState(() {
      entityLoadFunction = initialiseEntitiesToLoad();
    });
  }

  FutureBuilder<List<Vehicle>> getAsyncEntities(){
    return FutureBuilder<List<Vehicle>>(builder: (BuildContext ctxt, AsyncSnapshot<List<Vehicle>> snapshot) {
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

  _Section1State(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 1'),
      ),
      body: getAsyncEntities(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
            AddPage(repo: repo)
          )
        ).then((entity) => initStateAfterAdd(entity));
      },
        child: const Icon(Icons.add),
      ),
    );
  }


  ListView getEntityListView(List<Vehicle> entities){
    return ListView.builder(
        itemCount: entities.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap:() => {
              Fluttertoast.showToast(msg: "edit")
            },
            child: Card(
              color: Colors.lightBlue,
              child: Column(
                children: [
                  ListTile(title: Text(entities[index].license),subtitle: Text(entities[index].status + ' ' + entities[index].seats.toString()),trailing:
                  GestureDetector(
                    onTap: () => {
                      Fluttertoast.showToast(msg: "delete")
                    },
                    child: Container(
                        margin: const EdgeInsets.all(0.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 50,
                        )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

}