import 'package:flutter/material.dart';

class TextFieldHandler {
  final _TextController textController = _TextController();
  final _EnableController enableController = _EnableController();
  final _ValidationController validationController = _ValidationController();
}

class _ValidationController {
  var controllers = Map<String, String>();
  
}

class _EnableController {
  var controllers = Map<String, bool>();

  push(String identifier) {
    return controllers.putIfAbsent(identifier, () => true);
  }

  disableAll(bool value) {
    for (var item in controllers.keys) {
      if (item == null) continue;

      controllers[item] = value;
    }
  }
}

class _TextController {
  var controllers = Map<String, TextEditingController>();

  TextEditingController push(String identifier) {
    return controllers.putIfAbsent(identifier, () => TextEditingController(text: ''));
  }

  changeValue(Map<String, dynamic> object) {
    for (var item in object.keys) 
      controllers[item] = TextEditingController(text: object[item].toString());
  }

  Map<String, TextEditingController> getAllControllers() {
    return controllers;
  }
}
