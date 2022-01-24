import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';

class Section2 extends StatefulWidget {

  const Section2({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Section2> createState() => _Section2State(repo);
}

class _Section2State extends State<Section2> {

  final Repo repo;

  _Section2State(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 2'),
      ),
    );
  }
}