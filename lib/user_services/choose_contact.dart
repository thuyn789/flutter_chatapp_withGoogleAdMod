import 'package:chatapp_admod/user_services/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chatapp_admod/app_services/login.dart';
import 'package:chatapp_admod/user_services/chat_screen.dart';
import 'package:chatapp_admod/cloud_services/firebase_services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ChooseContact extends StatelessWidget {
  ChooseContact({
    required this.userObj,
    required this.signInMethod,
  });

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  //Sign in method
  //1 - Email/password
  //2 - Google social sign in
  //3 - Anonymous login
  final int signInMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent[100],
        title: Text(
          'Chat App',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => buildSignOutAlert(
                      context,
                      'Signing Out?',
                      'Do you want to sign out?'
                  )
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.blueAccent,
            ),
            label: Text(
              'Sign Out?',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: AuthServices().usersStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Something went wrong');
              } else if (snapshot.hasData) {
                return new ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> recipient =
                        document.data() as Map<String, dynamic>;
                    String firstname = recipient['first_name'];
                    String lastname = recipient['last_name'];
                    String name = '$firstname $lastname';
                    String urlAvatar = recipient['urlAvatar'];

                    return Card(
                      color: Colors.grey[200],
                      child: new ListTile(
                        onTap: () {
                          print("Click $name");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        userObj: userObj,
                                        signInMethod: signInMethod,
                                        recipient: recipient,
                                      )));
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(urlAvatar),
                          //backgroundImage: ,
                        ),
                        title: new Text(name),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text('No Users Found');
              }
          }
        },
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
          backgroundColor: Colors.brown,

          /// If true user is forced to close dial manually
          /// by tapping main button and overlay is not rendered.
          closeManually: false,
          children: [
            //check if admin is log in
            //this function is only available to admin
              SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
                label: 'Sign Out',
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.red),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => buildSignOutAlert(
                          context,
                          'Signing Out?',
                          'Do you want to sign out?'
                      )
                  );
                },
              ),
            SpeedDialChild(
              child: Icon(Icons.person_pin_rounded),
              backgroundColor: Colors.white,
              label: 'User Profile',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.red),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(userObj: userObj,),
                    ));
              },
            ),
          ]),
    );
  }

  Widget buildSignOutAlert(
      BuildContext context,
      String title,
      String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()));
            AuthServices().signOut();
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
