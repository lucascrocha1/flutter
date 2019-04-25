import 'package:flutter/material.dart';

class HandleChange {
  var controllers = Map<String, TextEditingController>();

  TextEditingController add(String identifier) {
    return controllers.putIfAbsent(identifier, () => TextEditingController(text: ''));
  }

  setValue(Map<String, dynamic> object) {
    for (var item in object.keys) {
      if (item == null)
        continue;

      controllers[item] = TextEditingController(text: object[item].toString());
    }
  }

  Map<String, TextEditingController> get() {
    return controllers;
  }
}