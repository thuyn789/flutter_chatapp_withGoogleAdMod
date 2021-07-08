import 'package:flutter/material.dart';
import 'package:chatapp_admod/cloud_services/firebase_services.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({
    required this.userObj,
  });

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
    final firstName = widget.userObj['first_name'];
    final lastName = widget.userObj['last_name'];
    final name = '$firstName $lastName';
    final email = widget.userObj['email'];
    final urlAvatar = widget.userObj['urlAvatar'];

    TextEditingController _firstName = TextEditingController(text: firstName);
    TextEditingController _lastName = TextEditingController(text: lastName);
    TextEditingController _email = TextEditingController(text: email);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.brown),
        backgroundColor: Colors.orangeAccent[100],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 30,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 35),
            Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlAvatar)),
                  SizedBox(width: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 20, color: Colors.brown),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(fontSize: 14, color: Colors.brown),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: _lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                hintText: 'name@email.com',
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
                labelText: 'Email Address',
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.blueAccent),
              child: MaterialButton(
                onPressed: () {
                  if(_email.text.isNotEmpty
                      && _firstName.text.isNotEmpty
                      && _lastName.text.isNotEmpty){
                    AuthServices().updateUser(
                        widget.userObj['user_id'],
                        _email.text,
                        _firstName.text,
                        _lastName.text
                    );

                    showDialog(
                        context: context,
                        builder: (context) => buildAlertBox(context, '', 'Update Successful')
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => buildAlertBox(context, 'Empty Field(s)', 'Please fill out the form completely')
                    );
                  }
                },
                child: Text(
                  'Update Your Info',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAlertBox(
      BuildContext context,
      String title,
      String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('OK'),
        ),
      ],
    );
  }
}