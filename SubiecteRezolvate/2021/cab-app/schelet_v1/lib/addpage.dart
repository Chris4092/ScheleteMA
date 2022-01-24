import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schelet_v1/repo/repo.dart';

import 'domain/entity.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.repo}) : super(key: key);

  final Repo repo;

  @override
  State<AddPage> createState() => _AddPageState(repo);
}

class _AddPageState extends State<AddPage> {
  final Repo repo;

  _AddPageState(this.repo);

  bool isLoading = false;

  final licenseController = TextEditingController();
  final statusController = TextEditingController();
  final driverController = TextEditingController();
  final cargoController = TextEditingController();
  final colorController = TextEditingController();
  final seatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add'),
        ),
        body: Container(
            decoration: const BoxDecoration(),
            child: ListView(children: <Widget>[
              TextField(
                controller: licenseController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'name'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'status'),
              ),
              TextField(
                controller: driverController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'one'),
              ),
              TextField(
                controller: cargoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'two'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'three'),
              ),
              TextField(
                controller: seatsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'intval'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              ElevatedButton(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(color: Colors.white),
                            // const SizedBox(width: 10),
                            Text('Loading...'),
                          ],
                        )
                      : const Text('Add Entity'),
                  onPressed: () async {
                    if (isLoading) return;

                    setState(() {
                      isLoading = true;
                    });
                    String license = licenseController.text;
                    String status = statusController.text;
                    String driver = driverController.text;
                    int? cargo = int.tryParse(cargoController.text);
                    String color = colorController.text;
                    int? seats = int.tryParse(seatsController.text);

                    Vehicle entity = Vehicle(0,license,status,driver,cargo!,color,seats!);
                    final added = await repo.addEntity(entity);
                    setState(() {
                      isLoading = true;
                    });
                    if(added.id == -1) {
                      Navigator.pop(context);
                    }
                    else {
                      Navigator.pop(context, added);
                    }

                  })
            ])));
  }
}
