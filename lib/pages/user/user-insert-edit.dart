import 'package:flutter/material.dart';
import 'user-service.dart';
import 'user.dart';
import '../../components/loader/loader.dart';
import 'package:flutter/scheduler.dart';
import '../../base/text-field-handler.dart';

class UserInsertEdit extends StatefulWidget {
  final int userId;

  UserInsertEdit({this.userId});

  @override
  _UserInsertEdit createState() => _UserInsertEdit(userId: this.userId);
}

class _UserInsertEdit extends State<UserInsertEdit> {
  final int userId;
  _UserInsertEdit({this.userId});

  var user = User();
  var textFieldHandler = TextFieldHandler();
  LoaderComponent loaderComponent;

  @override
  void initState() {
    super.initState();
    
    loaderComponent = LoaderComponent(textFieldHandler: textFieldHandler);

    SchedulerBinding
      .instance
      .addPostFrameCallback((_) => getUser());
  }

  loadUser() async {
    var response = await UserService().get('/api/person/get', {'id': this.userId});

    return User.fromJson(response);
  }

  getUser() async {
    loaderComponent.show();

    if (userId != null) {
      var userFromServer = await loadUser();
      textFieldHandler.textController.changeValue(userFromServer.toMap());

      setState(() {
        user = userFromServer;
      });
    }    

    loaderComponent.dismiss();
  }

  submit() async {
    loaderComponent.show();

    if (this.userId == null)
      await UserService().insert('api/person/insert', this.user.toMap());
    else
      await UserService().edit('api/person/edit', this.user.toMap());

    Navigator.pop(context, ['true']);

    loaderComponent.dismiss();
  }

  renderForm() {
    return Form(
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            new TextField(
              controller: textFieldHandler.textController.push('name'),
              enabled: textFieldHandler.enableController.push('name'),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Type your full name',
                  labelText: 'Name',
                  icon: Icon(Icons.person)),
              onChanged: (e) => user.name = e,
            ),
            new TextField(
              controller: textFieldHandler.textController.push('email'),
              enabled: textFieldHandler.enableController.push('email'),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter a valid email',
                  labelText: 'Email',
                  icon: Icon(Icons.email)),
              onChanged: (e) => user.email = e,
            ),
            new TextField(
              controller: textFieldHandler.textController.push('birthDate'),
              enabled: textFieldHandler.enableController.push('birthDate'),
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  hintText: 'Enter your birth date',
                  labelText: 'Birth date',
                  icon: Icon(Icons.date_range)),
              onChanged: (e) => user.birthDate = e,
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var appBarText = this.userId == null ? 'Insert User' : 'Edit User';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        leading: IconButton(icon: new Icon(Icons.arrow_back), 
            onPressed: () async {
            Navigator.pop(context, ['true']);
          }),
        actions: <Widget>[
          FlatButton(
            child: Text('Confirm'),
            textColor: Colors.white,
            onPressed: () { submit(); },
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[     
          loaderComponent,
          renderForm()
        ],
      ),
    );
  }
}
