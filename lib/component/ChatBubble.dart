import 'package:flutter/material.dart';

class chatBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  chatBubble({required this.sender,required this.text,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,

          children: [
            Text(sender,style: TextStyle(color: Colors.grey),),
            Material(
              elevation: 5.0,
              color: isMe?Colors.lightBlueAccent:Colors.white,
              borderRadius: BorderRadius.only(topLeft: isMe?Radius.circular(30):Radius.circular(0),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30),topRight: isMe?Radius.circular(0):Radius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,style: TextStyle(color: isMe?Colors.white:Colors.black,fontSize:18 ),),
              ),
            ),
          ],
        ),
    );
  }
}
