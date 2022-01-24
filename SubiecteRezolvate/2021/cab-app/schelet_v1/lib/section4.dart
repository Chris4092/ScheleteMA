import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';

class Section4 extends StatefulWidget {

  const Section4({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Section4> createState() => _Section4State(repo);
}

class _Section4State extends State<Section4> {

  final Repo repo;

  _Section4State(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 4'),
      ),
    );
  }
}