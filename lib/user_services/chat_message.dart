import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    required this.text,
    required this.name,
    required this.date,
    required this.urlAvatar,
  });

  final String text;
  final String name;
  final String date;
  final String urlAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(urlAvatar),
              //backgroundImage: ,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 14.0, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(width: 40),
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: 14.0, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}