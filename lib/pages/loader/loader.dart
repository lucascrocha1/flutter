import 'package:flutter/material.dart';

class LoaderComponent extends StatefulWidget {
  final BuildContext context;
  _LoaderComponent state;

  LoaderComponent({ this.context });

  @override
  _LoaderComponent createState() {
    state = _LoaderComponent(context: this.context);

    return state;
  }
}

class _LoaderComponent extends State<LoaderComponent> {
  final BuildContext context;

  _LoaderComponent({ this.context });

  var isLoading = false;

  show() {
    print(context.widget);

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
  Widget build(context) {
    if (!isLoading)
      return Container();
    
    return renderAlert();
  }
}