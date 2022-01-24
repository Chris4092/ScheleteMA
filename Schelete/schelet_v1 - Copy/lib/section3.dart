import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schelet_v1/repo/repo.dart';

class Section3 extends StatefulWidget {

  const Section3({Key? key, required this.repo}) : super(key: key);

  final Repo repo;
  @override
  State<Section3> createState() => _Section3State(repo);
}

class _Section3State extends State<Section3> {

  final Repo repo;

  _Section3State(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section 3'),
      ),
    );
  }
}