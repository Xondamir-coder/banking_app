import 'dart:convert';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CategoryModel {
  final String name;
  final String iconPath;

  CategoryModel({
    required this.name,
    required this.iconPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'icon_path': iconPath,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      iconPath: map['icon_path'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
