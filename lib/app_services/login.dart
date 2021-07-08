import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:chatapp_admod/admod_services/ad_helper.dart';
import 'package:chatapp_admod/app_services/signup.dart';
import 'package:chatapp_admod/user_services/choose_contact.dart';
import 'package:chatapp_admod/cloud_services/firebase_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _hideText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 75),
            //Page Title
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            //Subtitle
            Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 75),
            //Text field for email
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
            SizedBox(height: 5),
            //Text field for password
            TextFormField(
              obscureText: _hideText,
              controller: _password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hideText = !_hideText;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye))),
            ),
            SizedBox(height: 10),
            //Forgot password button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () {
                      print('Forgot button clicked');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    )),
              ],
            ),
            SizedBox(height: 15),
            //Login button
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.orangeAccent[100]),
              child: MaterialButton(
                //When clicked, the app will contact firebase for authentication
                //using user's inputted login credential
                onPressed: () async {
                  bool successful = await AuthServices()
                      .login(_email.text.trim(), _password.text.trim());
                  if (successful) {
                    //when successful, navigate user to home page
                    DocumentSnapshot database =
                        await AuthServices().retrieveUserData();
                    final userObj = database.data() as Map<String, dynamic>;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseContact(
                                  userObj: userObj,
                                  signInMethod: 0,
                                )
                        )
                    );
                  } else {
                    //when not successful, popup alert
                    //and prompt user to try again
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Incorrect email/password. Please try again!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        });
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            //Google sign in
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0), color: Colors.red),
              child: MaterialButton(
                //When clicked, the app will contact firebase for authentication
                //using user's inputted login credential
                onPressed: () async {
                  await AuthServices()
                      .signInWithGoogle();

                  DocumentSnapshot database = await AuthServices().retrieveUserData();
                  final userObj = database.data() as Map<String, dynamic>;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseContact(
                            userObj: userObj,
                            signInMethod: 1,
                          )
                      )
                  );
                },
                child: Text(
                  'Login with Google',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            //Anonymous sign-in
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0), color: Colors.blueAccent),
              child: MaterialButton(
                //When clicked, the app will contact firebase for authentication
                //using user's inputted login credential
                onPressed: () async {
                  await AuthServices()
                      .signInAnon();

                  DocumentSnapshot database = await AuthServices().retrieveUserData();
                  final userObj = database.data() as Map<String, dynamic>;

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseContact(
                            userObj: userObj,
                            signInMethod: 1,
                          )
                      )
                  );
                },
                child: Text(
                  'Login Anonymously',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            //Create new account button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'First Time to Fan App?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text(
                      'Create New Account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose a BannerAd object
    //_myBanner.dispose();

    // Dispose an InterstitialAd object
    //_interstitialAd?.dispose();

    // Dispose a RewardedAd object
    //_rewardedAd?.dispose();

    super.dispose();
  }
}
