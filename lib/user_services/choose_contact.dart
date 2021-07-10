import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:chatapp_admod/admod_services/ad_helper.dart';
import 'package:chatapp_admod/app_services/login.dart';
import 'package:chatapp_admod/user_services/chat_screen.dart';
import 'package:chatapp_admod/user_services/user_profile.dart';
import 'package:chatapp_admod/cloud_services/firebase_services.dart';

class ChooseContact extends StatefulWidget {
  ChooseContact({
    required this.userObj,
    required this.signInMethod,
  });

  //User Object - A map of DocumentSnapshot
  //Contain user information, name, uid, and email
  final userObj;

  //Sign in method
  //0 - Email/password
  //1 - Google social sign in
  //2 - Anonymous login
  final int signInMethod;

  @override
  _ChooseContactState createState() => _ChooseContactState();
}

class _ChooseContactState extends State<ChooseContact> {
  //Banner Ad variables
  late BannerAd _myBanner;
  bool _isBannerAdReady = false;

  //Interstitial ad variables
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _myBanner = _loadBannerAd();
    _myBanner.load();

    _loadInterstitialAd();
  }

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
                      context, 'Signing Out?', 'Do you want to sign out?'));
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
      body: SafeArea(
        child: Stack(children: [
          StreamBuilder<QuerySnapshot>(
            stream: AuthServices().usersStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                        userObj: widget.userObj,
                                        signInMethod: widget.signInMethod,
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
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _myBanner.size.width.toDouble(),
                height: _myBanner.size.height.toDouble(),
                child: AdWidget(ad: _myBanner),
              ),
            ),
          //if (_isInterstitialAdReady)
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
                onPressed: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd?.show();
                  }
                },
                child: Text(
                  'Click here for interstitial ad',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )),
          ),
        ]),
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
                        context, 'Signing Out?', 'Do you want to sign out?'));
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
                      builder: (context) => UserProfilePage(
                        userObj: widget.userObj,
                      ),
                    ));
              },
            ),
          ]),
    );
  }

  Widget buildSignOutAlert(BuildContext context, String title, String content) {
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
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            AuthServices().signOut();
          },
          child: Text('Yes'),
        ),
      ],
    );
  }

  BannerAd _loadBannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ChooseContact(
                  userObj: widget.userObj,
                  signInMethod: widget.signInMethod)));
              ad.dispose();
            },

            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Dispose a BannerAd object
    _myBanner.dispose();

    // Dispose an InterstitialAd object
    _interstitialAd?.dispose();

    super.dispose();
  }
}
