import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chatapp_admod/cloud_services/firebase_services.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: AuthServices().userDataStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Something went wrong'));
              } else if (snapshot.hasData) {
                final userObj = snapshot.data!.data() as Map<String, dynamic>;
                return buildTextForm(
                  userObj['first_name'],
                  userObj['last_name'],
                  userObj['email'],
                  userObj['urlAvatar'],
                );
              } else {
                return Center(child: Text('No Users Found'));
              }
          }
        },
      ),
    );
  }

  Widget buildTextForm(
      String firstName,
      String lastName,
      String email,
      String urlAvatar){
    TextEditingController _firstName = TextEditingController(text: firstName);
    TextEditingController _lastName = TextEditingController(text: lastName);
    TextEditingController _email = TextEditingController(text: email);

    String name = '$firstName $lastName';

    return Container(
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
                      _email.text.trim(),
                      _firstName.text.trim(),
                      _lastName.text.trim()
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