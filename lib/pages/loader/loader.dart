import 'package:flutter/material.dart';

class LoaderComponent extends StatefulWidget {
  final GlobalKey key;
  _LoaderComponent state;

  LoaderComponent({ this.key });

  @override
  _LoaderComponent createState() {
    state = _LoaderComponent(key: this.key);

    return state;
  }
}

class _LoaderComponent extends State<LoaderComponent> {
  final GlobalKey key;

  _LoaderComponent({ this.key });

  var isLoading = false;

  show() {
    print(key);

    FocusScope.of(context).requestFocus(new FocusNode());
    changeLoadingState(true);
  }

  dimiss() {
    FocusScope.of(context).requestFocus(new FocusNode());
    changeLoadingState(false);
  }

  changeLoadingState(bool value) {
    setState(() {
      isLoading = value; 
    });
  }  

  renderAlert() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(color: Colors.grey, dismissible: false),
        ),
        AlertDialog(
          backgroundColor: Colors.white,
          content: Stack(
            children: <Widget>[
              CircularProgressIndicator()              
            ],
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading)
      return Container();
    
    return renderAlert();
  }
}