import 'package:chat/chatDetailPage.dart';
import 'package:flutter/material.dart';
class ChatUsersList extends StatefulWidget {
  String msgDocId;
  String text;
  String secondarytext;
  String image;
  String time;

   ChatUsersList({@required this.text, @required this.secondarytext, @required this.image,@required this.time,this.msgDocId});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context){
           return ChatDetailPage(receiverName: widget.text,msgDocId: widget.msgDocId,);
         }));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.text,style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),),
                        SizedBox(height: 15,),
                        Text(widget.secondarytext,style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(
              fontSize: 14,color: Colors.grey.shade500
            ),),

          ],
        ),
      ),
    );
  }
}
