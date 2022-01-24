import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schelet_v1/dialogue.dart';
import 'package:schelet_v1/domain/entity.dart';
import 'package:schelet_v1/repo/repo.dart';

class DeletePage extends StatefulWidget {

  const DeletePage({Key? key, required this.repo, required this.color}) : super(key: key);
  final String color;
  final Repo repo;
  @override
  State<DeletePage> createState() => _DeletePageState(repo, color);
}

class _DeletePageState extends State<DeletePage> {

  final Repo repo;

  final String color;

  _DeletePageState(this.repo, this.color);

  late Future<List<Vehicle>> entityLoadFunction;


  Future<List<Vehicle>> initialiseVehiclesToLoad() async {
    List<Vehicle> vehicles = await repo.getVehiclesByColor(color);
    print(vehicles.length);
    return vehicles;
  }

  void initState() {
    setState(() {
      entityLoadFunction = initialiseVehiclesToLoad();
    });
  }

  FutureBuilder<List<Vehicle>> getAsyncEntities() {
    return FutureBuilder<List<Vehicle>>(
      builder: (BuildContext ctxt, AsyncSnapshot<List<Vehicle>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return getVehiclesListView(snapshot.data!);
        }
        else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            Padding(padding:
            const EdgeInsets.only(top: 16),
                child: Text("Error: ${snapshot.error}")
            )
          ];
        }
        else {
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
        return Center(child: Column(
          children: children, mainAxisAlignment: MainAxisAlignment.center,));
      },
      future: entityLoadFunction,
    );
  }

  ListView getVehiclesListView(List<Vehicle> vehicles) {
    return ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Card(
            color: Colors.lightBlue,
            child: Column(
              children: [
                ListTile(title: Text(vehicles[index].license),
                  subtitle: Text(vehicles[index].status + ' ' +
                      vehicles[index].seats.toString()),
                  trailing:
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context, vehicles[index], repo);
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


  showAlertDialog(BuildContext context, Vehicle vehicle, Repo repo) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10.0)
                ),
                width: 300.0,
                height: 200.0,
                alignment: AlignmentDirectional.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: const Center(
                        child: Text(
                          "loading.. wait...",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        Vehicle? deletedVehicle = await repo.deleteEntity(vehicle.id);
        if (deletedVehicle != null) {
          Navigator.pop(context);
          Navigator.of(context).pop();
          initState();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Would you like to delete the selected character?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}