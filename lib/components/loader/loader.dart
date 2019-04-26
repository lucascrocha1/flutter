import 'package:flutter/material.dart';
import '../../base/text-field-handler.dart';

class LoaderComponent extends StatefulWidget {
  final TextFieldHandler textFieldHandler;
  _LoaderComponent _state;

  show() {
    _state.show();
  }

  dismiss() {
    _state.dismiss();
  }

  LoaderComponent({ this.textFieldHandler });

  @override
  _LoaderComponent createState() {
    _state = _LoaderComponent(textFieldHandler: this.textFieldHandler);

    return _state;
  }
}

class _LoaderComponent extends State<LoaderComponent> {
  final TextFieldHandler textFieldHandler;

  _LoaderComponent({ this.textFieldHandler });

  var isLoading = false;

  clearFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  show() {
    textFieldHandler.enableController.disableAll(false);
    clearFocus();
    changeLoadingState(true);
  }

  dismiss() {
    textFieldHandler.enableController.disableAll(true);
    clearFocus();
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
              LinearProgressIndicator()    
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