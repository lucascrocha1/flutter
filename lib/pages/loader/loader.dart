import 'package:flutter/material.dart';

class LoaderComponent extends StatefulWidget {
  final GlobalKey formKey;
  _LoaderComponent state;

  LoaderComponent({ this.formKey });

  @override
  _LoaderComponent createState() {
    state = _LoaderComponent(formKey: this.formKey);

    return state;
  }
}

class _LoaderComponent extends State<LoaderComponent> {
  final GlobalKey formKey;

  _LoaderComponent({ this.formKey });

  var isLoading = false;

  show() {
    print(formKey);

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