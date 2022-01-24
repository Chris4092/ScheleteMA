import 'dart:convert';

import 'dart:core';

const String tableName = "Vehicles";

class VehicleFields{
  static const String id = '_id';
  static const String license = 'license';
  static const String status = 'status';
  static const String driver = 'driver';
  static const String cargo = 'cargo';
  static const String color = 'color';
  static const String seats = 'seats';
}


class Vehicle{
  int id;
  String license;
  String status;
  String driver;
  int cargo;
  String color;
  int seats;

  Vehicle(this.id, this.license, this.status, this.driver, this.cargo, this.color, this.seats);


  Map<String, Object?> toJson() => {
    VehicleFields.id : id,
    VehicleFields.license : license,
    VehicleFields.status : status,
    VehicleFields.driver : driver,
    VehicleFields.cargo : cargo,
    VehicleFields.color : color,
    VehicleFields.seats : seats
  };

  Vehicle copy({int? id, String? license, String? status, String? driver, int? cargo, String? color, int? seats}) =>
      Vehicle(id??this.id, license??this.license, status??this.status, driver??this.driver, cargo??this.cargo, color??this.color, seats??this.seats);


  static Vehicle fromJson(Map<String, Object?> json) =>
      Vehicle(json[VehicleFields.id] as int,
          json[VehicleFields.license] as String,
          json[VehicleFields.status] as String,
          json[VehicleFields.driver] as String,
          json[VehicleFields.cargo] as int,
          json[VehicleFields.color] as String,
          json[VehicleFields.seats] as int);

  factory Vehicle.fromServer(Map<String, dynamic> json) =>
    Vehicle(json['id'], json['license'], json['status'], json['driver'], json['cargo'], json['color'], json['seats']);


}