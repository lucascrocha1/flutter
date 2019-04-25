import 'package:flutter/material.dart';
import 'user-service.dart';
import 'user.dart';
import '../loader/loader.dart';
import 'package:flutter/scheduler.dart';
import '../../base/handle-change.dart';

class UserInsertEdit extends StatefulWidget {
  final int userId;

  UserInsertEdit({this.userId});

  @override
  _UserInsertEdit createState() => _UserInsertEdit(userId: this.userId);
}

class _UserInsertEdit extends State<UserInsertEdit> {
  final int userId;

  var user = User();

  var handleChange = HandleChange();

  var formKey = new GlobalKey<FormState>();

  LoaderComponent loaderComponent;

  _UserInsertEdit({this.userId});

  @override
  void initState() {
    loaderComponent = LoaderComponent(handleChange: handleChange);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => getUser());
  }

  getUser() async {
    loaderComponent.state.show();

    var userFromServer = User();

    if (userId != null) {
      var response = await UserService().get('/api/person/get', {'id': this.userId});
      userFromServer = User.fromJson(response);
      handleChange.setValue(userFromServer.toMap());
    }

    setState(() {
      user = userFromServer;
    });

    loaderComponent.state.dimiss();
  }

  submit() async {
    loaderComponent.state.show();

    if (this.userId == null)
      await UserService().insert('api/person/insert', this.user.toMap());
    else
      await UserService().edit('api/person/edit', this.user.toMap());

    Navigator.pop(context, ['true']);

    loaderComponent.state.dimiss();
  }

  renderForm() {
    return Form(
        key: formKey,
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            new TextField(
              controller: handleChange.add('name'),
              enabled: handleChange.addDisabled('name'),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Type your full name',
                  labelText: 'Name',
                  icon: Icon(Icons.person)),
              onChanged: (e) => user.name = e,
            ),
            new TextField(
              controller: handleChange.add('email'),
              enabled: handleChange.addDisabled('email'),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter a valid email',
                  labelText: 'Email',
                  icon: Icon(Icons.email)),
              onChanged: (e) => user.email = e,
            ),
            new TextField(
              controller: handleChange.add('birthDate'),
              enabled: handleChange.addDisabled('birthDate'),
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
