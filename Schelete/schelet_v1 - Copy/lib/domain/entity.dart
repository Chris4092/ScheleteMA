import 'dart:convert';

import 'dart:core';

const String tableName = "Entities";

class EntityFields{
  static const String id = '_id';
  static const String name = 'name';
  static const String status = 'status';
  static const String one = 'one';
  static const String two = 'two';
  static const String three = 'three';
  static const String intval = 'intval';
}


class Entity{
  int id;
  String name;
  String status;
  String one;
  String two;
  String three;
  int intval;

  Entity(this.id, this.name, this.status, this.one, this.two, this.three, this.intval);


  Map<String, Object?> toJson() => {
    EntityFields.id : id,
    EntityFields.name : name,
    EntityFields.status : status,
    EntityFields.one : one,
    EntityFields.two : two,
    EntityFields.three : three,
    EntityFields.intval : intval
  };

  Entity copy({int? id, String? name, String? status, String? one, String? two, String? three, int? intval}) =>
      Entity(id??this.id, name??this.name, status??this.status, one??this.one, two??this.two, three??this.three, intval??this.intval);


  static Entity fromJson(Map<String, Object?> json) =>
      Entity(json[EntityFields.id] as int,
          json[EntityFields.name] as String,
          json[EntityFields.status] as String,
          json[EntityFields.one] as String,
          json[EntityFields.two] as String,
          json[EntityFields.three] as String,
          json[EntityFields.intval] as int);

  factory Entity.fromServer(Map<String, dynamic> json) =>
    Entity(json['id'], json['name'], json['status'], json['one'], json['two'], json['three'], json['intval']);


}