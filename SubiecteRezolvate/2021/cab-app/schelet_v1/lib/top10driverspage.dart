import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schelet_v1/addpage.dart';
import 'package:schelet_v1/repo/repo.dart';

import 'domain/dto.dart';
import 'domain/entity.dart';

class Top10DriversPage extends StatefulWidget {

  const Top10DriversPage({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Top10DriversPage> createState() => _Top10DriversPageState(repo);
}

class _Top10DriversPageState extends State<Top10DriversPage> {

  final Repo repo;

  late Future<List<DTO>> entityLoadFunction;

  Future<List<DTO>> initialiseEntitiesToLoad() async {
    List<DTO> entities = await repo.gettop10drivers();
    return entities;
  }


  void initState() {
    setState(() {
      entityLoadFunction = initialiseEntitiesToLoad();
    });
  }

  FutureBuilder<List<DTO>> getAsyncEntities(){
    return FutureBuilder<List<DTO>>(builder: (BuildContext ctxt, AsyncSnapshot<List<DTO>> snapshot) {
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

  _Top10DriversPageState(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 1'),
      ),
      body: getAsyncEntities(),

    );
  }


  ListView getEntityListView(List<DTO> entities){
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
                  ListTile(title: Text(entities[index].driver),subtitle:Text(entities[index].number.toString()))
                ],
              ),
            ),
          );
        });
  }

}