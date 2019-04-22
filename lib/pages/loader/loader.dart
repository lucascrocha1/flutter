import 'package:flutter/material.dart';

class LoaderComponent extends StatefulWidget {
  final String message;

  LoaderComponent({ this.message });

  @override
  _LoaderComponent createState() => _LoaderComponent(message: this.message);
}

class _LoaderComponent extends State<LoaderComponent> {
  final String message;

  _LoaderComponent({ this.message });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey)
          ),
          new Center (
            child: CircularProgressIndicator(),
          )
        ],
      )
    );
  }
}