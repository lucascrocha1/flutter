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
  var emptyUsers = false;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    changeLoadingState(true);

    var response = await UserService().get('/api/person/list', { 'search': null, 'pageSize': 500, 'pageIndex': 1 });

    setState(() {
      users = response.map((model) => User.fromJson(model)).toList();
      emptyUsers = users.length == 0;
    });

    changeLoadingState(false);
  }

  changeLoadingState(bool value) {
    setState(() {
      isLoading = value;
    });
  }  

  deleteUser(int userId) async {
    changeLoadingState(true);
    await UserService().delete('api/person/delete', {'id': userId});
    await getUsers();
  }

  pushPage(int userId) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => UserInsertEdit(userId: userId)))
      .then((val) {
        if (val != null && val.isNotEmpty) 
          getUsers();
    });
  }

  showDeleteAlert(int userId) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete user'),
            content: Text('This action cannot be undone.'),
            actions: <Widget>[
              new FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text('Delete',
    style: TextStyle(wordSpacing: 2.0,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                textColor: Colors.blue,
                onPressed: () async {
                  await deleteUser(userId);
                },
              )
            ],
          );
      });
  }

  renderList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].email),
          trailing: IconButton(
              icon: new Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                await showDeleteAlert(users[index].id);
              }),
          onTap: () {
            pushPage(users[index].id);
          },
        );
      },
    );
  }

  renderLoader() {
    return Center(child: CircularProgressIndicator());
  }

  renderNoResults() {
    return Center(child: Text('No result'));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: isLoading
          ? renderLoader() 
          : emptyUsers 
          ? renderNoResults() 
          : renderList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushPage(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
