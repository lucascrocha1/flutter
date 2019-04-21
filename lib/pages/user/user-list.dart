import 'package:flutter/material.dart';
import 'user-service.dart';
import 'user.dart';
import 'user-insert-edit.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  var users = List<dynamic>();

  getUsers() async {
    var response = await UserService()
      .get('/api/person/list', { 'search': null, 'pageSize': 500, 'pageIndex': 1 });

    setState(() {
      users = response.map((model) => User.fromJson(model)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users')
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(users[index].name),
            subtitle: Text(users[index].email),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserInsertEdit(userId: users[index].id)))
                .then((val) { 
                  if (val != null && val.isNotEmpty)
                    getUsers();
                 });
            },
          );
        },
      ),
    );
  }
}