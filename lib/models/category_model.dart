import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CategoryModel {
  final String name;
  final IconData iconData;
  final String id;

  CategoryModel({
    required this.name,
    required this.iconData,
    String? id,
  }) : id = uuid.v4();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'iconData': iconData,
      'id': id,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      iconData: map['iconData'] as IconData,
      // iconData: map['iconString'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
