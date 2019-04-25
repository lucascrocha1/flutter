import 'package:flutter/material.dart';
import '../../base/handle-change.dart';

class LoaderComponent extends StatefulWidget {
  final HandleChange handleChange;
  _LoaderComponent state;

  LoaderComponent({ this.handleChange });

  @override
  _LoaderComponent createState() {
    state = _LoaderComponent(handleChange: this.handleChange);

    return state;
  }
}

class _LoaderComponent extends State<LoaderComponent> {
  final HandleChange handleChange;

  _LoaderComponent({ this.handleChange });

  var isLoading = false;

  show() {
    handleChange.disableAll(false);
    FocusScope.of(context).requestFocus(new FocusNode());
    changeLoadingState(true);
  }

  dimiss() {
    handleChange.disableAll(true);
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