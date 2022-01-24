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

  final nameController = TextEditingController();
  final statusController = TextEditingController();
  final oneController = TextEditingController();
  final twoController = TextEditingController();
  final threeController = TextEditingController();
  final intvalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add'),
        ),
        body: Container(
            decoration: const BoxDecoration(),
            child: Column(children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'name'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'status'),
              ),
              TextField(
                controller: oneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'one'),
              ),
              TextField(
                controller: twoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'two'),
              ),
              TextField(
                controller: threeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'three'),
              ),
              TextField(
                controller: intvalController,
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
                    String name = nameController.text;
                    String status = statusController.text;
                    String one = oneController.text;
                    String two = twoController.text;
                    String three = threeController.text;
                    int? intval = int.tryParse(intvalController.text);

                    Entity entity = Entity(0,name,status,one,two,three,intval!);
                    final added = await repo.addEntity(entity);

                    setState(() {
                      isLoading = true;
                    });

                    Navigator.pop(context, added);

                  })
            ])));
  }
}
