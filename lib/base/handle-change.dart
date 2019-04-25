import 'package:flutter/material.dart';

class HandleChange {
  var controllers = Map<String, TextEditingController>();
  // ToDo: i do not like this, i don't know, i'll change everything here i think
  var controllersDisableds = Map<String, bool>();

  TextEditingController add(String identifier) {
    return controllers.putIfAbsent(identifier, () => TextEditingController(text: ''));
  }

  // ToDo: i do not like this, i don't know, i'll change everything here i think
  addDisabled(String identifier) {
    return controllersDisableds.putIfAbsent(identifier, () => true);
  }

// ToDo: i do not like this, i don't know, i'll change everything here i think
  disableAll(bool value) {
    for (var item in controllersDisableds.keys) {
      if (item == null)
        continue;

      controllersDisableds[item] = value;
    }
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