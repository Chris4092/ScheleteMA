import 'dart:convert';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schelet_v1/domain/dto.dart';
import 'package:schelet_v1/domain/entity.dart';
import 'package:schelet_v1/repo/local_db.dart';

import 'package:http/http.dart' as http;

class Repo {

  LocalDB db = LocalDB.instance;

  String url = "http://192.168.0.105:2021";




  List<Vehicle> entities = <Vehicle>[];

  Vehicle? lastDeleted;

  Future<Vehicle> addEntity(Vehicle entity) async {
    //daca n ai server, daca ai sterge asta sau pune o pe un if

    final uri = Uri.parse(url + "/vehicle");
    http.Response response;
    Vehicle? added;
    try{
      response = await http.post(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'}, body: jsonEncode(entity));
      if(response.statusCode == 200){
        Vehicle vehicle = Vehicle.fromServer(jsonDecode(response.body));
        added = await db.create(vehicle);
        FlutterLogs.logInfo("Success", "Server + localDB", "added entity: $vehicle");
      }
      else{
        Fluttertoast.showToast(msg: 'Unexpected status code from server: ' + response.statusCode.toString());
        FlutterLogs.logInfo("Error", "Server + localDB", "not added entity: $entity");
        return Vehicle(-1, "", "", "", -1, "", -1);

      }
    }
    catch(e){
      entity.id = nextId();
      added = await db.create(entity);
      Fluttertoast.showToast(msg: 'Server connection failed, added to localdb instead');
      FlutterLogs.logInfo("Success", "localDB", "added entity: $added");
    }
    entities.add(added);
    return added;
  }

  Future<Vehicle?> updateEntity(Vehicle entity) async{
    final uri = Uri.parse(url + "/vehicle");
    http.Response response;
    Vehicle? updated;
    try{
      response = await http.put(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'}, body: jsonEncode(entity));
      if(response.statusCode == 200){
        Vehicle vehicle = Vehicle.fromServer(jsonDecode(response.body));
        updated = await db.update(vehicle);
        FlutterLogs.logInfo("Success", "Server + localDB", "updated entity: $vehicle");
      }
      else{
        Fluttertoast.showToast(msg: 'Unexpected status code from server: ' + response.statusCode.toString());
        FlutterLogs.logInfo("Error", "Server + localDB", "not updated entity: $entity");
        return Vehicle(-1, "", "", "", -1, "", -1);

      }
    }
    catch(e){
      updated = await db.update(entity);
      Fluttertoast.showToast(msg: 'Server connection failed, updated to localdb instead');
      FlutterLogs.logInfo("Success", "localDB", "updated entity: $updated");
    }

    entities.removeWhere((element) => element.id == updated!.id);
    entities.add(updated);
    return updated;
  }

  Future<Vehicle?> deleteEntity(int id) async {
    final uri = Uri.parse(url + "/vehicle/" + id.toString());
    http.Response response;
    Vehicle? deleted;
    try{
      response = await http.delete(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        deleted = Vehicle.fromServer(jsonDecode(response.body));
        await db.delete(id);
        entities.remove(deleted);
        FlutterLogs.logInfo("Success", "Server + localDB", "deleted entity: $deleted");
      }
      else{
        Fluttertoast.showToast(msg: 'Unexpected status code from server: ' + response.statusCode.toString());
        FlutterLogs.logInfo("Error", "Server + localDB", "didnt delete entity");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed');
      FlutterLogs.logInfo("Error", "Server + localDB", "didnt delete entity");
    }
    return deleted;

  }

  Future<List<String>> getColors() async{
    final uri = Uri.parse(url + "/colors");
    http.Response response;
    List<String> colors = <String>[];
    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        for(var json in jsonList){
          colors.add(json);
        }
        FlutterLogs.logInfo("Success", "Server", "colors brought");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed, retry later');
      FlutterLogs.logInfo("Error", "Server", "colors not brought");
    }
    return colors;

  }

  Future<List<Vehicle>> getVehiclesByColor(String color) async{
    final uri = Uri.parse(url + "/vehicles/" + color);
    http.Response response;
    List<Vehicle> vehicles = <Vehicle>[];
    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        for(var json in jsonList){
          vehicles.add(Vehicle.fromServer(json));
        }
        FlutterLogs.logInfo("Success", "Server", "vehicles brought");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed, retry later');
      FlutterLogs.logInfo("Error", "Server", "vehicles not brought");
    }
    return vehicles;

  }


  Future<List<Vehicle>> getAll() async {
    final uri = Uri.parse(url + "/review");
    http.Response response;

    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        await db.empty();
        entities.clear();
        for(var json in jsonList){
          Vehicle vehicle = Vehicle.fromServer(json);
          await db.create(vehicle);
          entities.add(vehicle);
        }
        FlutterLogs.logInfo("Success", "Server", "vehicles brought");
      }
    }
    catch(e){
      entities = await db.getAll();
      Fluttertoast.showToast(msg: 'Server connection failed,results from localdb shown instead');
      FlutterLogs.logInfo("Error", "Server", "vehicles not brought");
    }
    return entities;
  }


  int nextId() {
    int id = 0;
    entities.forEach((entity) {
      if(entity.id >= id) {
          id = entity.id + 1;
      }
    });
    return id;
  }

  Future<List<Vehicle>> gettop10vehicles() async{
    final uri = Uri.parse(url + "/all");
    http.Response response;
    List<Vehicle> vehicleListCrude = <Vehicle>[];
    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        for(var json in jsonList){
          Vehicle vehicle = Vehicle.fromServer(json);
          vehicleListCrude.add(vehicle);
        }
        vehicleListCrude.sort((v1, v2) => v1.seats.compareTo(v2.seats));
        vehicleListCrude = vehicleListCrude.reversed.take(10).toList();
        FlutterLogs.logInfo("Success", "Server", "vehicles brought");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed');
      FlutterLogs.logInfo("Error", "Server", "vehicles not brought");
    }
    return vehicleListCrude;
  }

  Future<List<Vehicle>> gettop5vehicles() async{
    final uri = Uri.parse(url + "/all");
    http.Response response;
    List<Vehicle> vehicleListCrude = <Vehicle>[];
    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        for(var json in jsonList){
          Vehicle vehicle = Vehicle.fromServer(json);
          vehicleListCrude.add(vehicle);
        }
        vehicleListCrude.sort((v1, v2) => v1.cargo.compareTo(v2.cargo));
        vehicleListCrude = vehicleListCrude.reversed.take(5).toList();
        FlutterLogs.logInfo("Success", "Server", "vehicles brought");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed');
      FlutterLogs.logInfo("Error", "Server", "vehicles not brought");
    }
    return vehicleListCrude;
  }

  Future<List<DTO>> gettop10drivers() async{
    final uri = Uri.parse(url + "/all");
    http.Response response;
    Map<String, int> dict = {};
    Map<String, int> sortedMap = {};
    List<DTO> dtoList = <DTO>[];
    try{
      response = await http.get(uri, headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'});
      if(response.statusCode == 200){
        var jsonList = jsonDecode(response.body);
        for(var json in jsonList){
          Vehicle vehicle = Vehicle.fromServer(json);
          if(dict.containsKey(vehicle.driver)){
            dict[vehicle.driver] = dict[vehicle.driver]! + 1;
          }
          else{
            dict[vehicle.driver] = 1;
          }
        }
        sortedMap = Map.fromEntries(
          dict.entries.toList()..sort((e1,e2) => e2.value.compareTo(e1.value))
        );
        sortedMap.forEach((key, value) {
          dtoList.add(DTO(key, value));
        });
        dtoList = dtoList.take(10).toList();
        FlutterLogs.logInfo("Success", "Server", "drivers brought");
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Server connection failed');
      FlutterLogs.logInfo("Error", "Server", "drivers not brought");
    }
    return dtoList;
  }


  void connectToBroadcast(){
    final channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.0.105:2021"),
    );
    channel.stream.listen(
            (data) {
              Fluttertoast.showToast(msg: data.toString());
            },
        onError:(error) => Fluttertoast.showToast(msg: error.toString()),
    );
  }

}

Future<Repo> getRepo() async{



  Repo repo = Repo();
  repo.connectToBroadcast();
  await repo.getAll();

  return repo;
}