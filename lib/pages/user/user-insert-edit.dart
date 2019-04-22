import 'package:flutter/material.dart';
import 'user-service.dart';
import 'user.dart';

class UserInsertEdit extends StatefulWidget {
  final int userId;

  UserInsertEdit({this.userId});

  @override
  _UserInsertEdit createState() => _UserInsertEdit(userId: this.userId);
}

class _UserInsertEdit extends State<UserInsertEdit> {
  final int userId;

  var user = User();
  // ToDo: do a better code to make generic to control all the input fields
  var txtName = new TextEditingController();
  var txtEmail = new TextEditingController();
  var txtBirthDate = new TextEditingController();

  _UserInsertEdit({this.userId});

  getUser() async {
    var userFromServer = User();

    if (userId != null) {
      var response = await UserService().get('/api/person/get', {'id': this.userId});
      userFromServer = User.fromJson(response);
      txtName.text = userFromServer.name;
      txtEmail.text = userFromServer.email;
      txtBirthDate.text = userFromServer.birthDate;
    }

    setState(() {
      user = userFromServer;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  submit() async {
    if (this.userId == null)
      await UserService().insert('api/person/insert', this.user.toMap());
    else
      await UserService().edit('api/person/edit', this.user.toMap());

    Navigator.pop(context, ['true']);
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
      body: Form(
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            new TextField(
              controller: txtName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Type your full name',
                  labelText: 'Name',
                  icon: Icon(Icons.person)),
              onChanged: (e) => user.name = e,
            ),
            new TextField(
              controller: txtEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter a valid email',
                  labelText: 'Email',
                  icon: Icon(Icons.email)),
              onChanged: (e) => user.email = e,
            ),
            new TextField(
              controller: txtBirthDate,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  hintText: 'Enter your birth date',
                  labelText: 'Birth date',
                  icon: Icon(Icons.date_range)),
              onChanged: (e) => user.birthDate = e,
            ),
          ],
        ),
      ),
    );
  }
}
