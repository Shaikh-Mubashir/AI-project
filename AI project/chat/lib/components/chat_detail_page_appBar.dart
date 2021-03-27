import 'package:flutter/material.dart';
class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),
                  onPressed: (){
                Navigator.pop(context);
                  }

                  ),
              SizedBox( width: 6,),
              CircleAvatar(
                maxRadius: 20,
                backgroundImage: AssetImage('images/userImage4.jpg'),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Raheel',style: TextStyle(
                      fontWeight: FontWeight.w600
                          ,fontSize: 20
                    ),),

                    Text('Online',style: TextStyle(
                        color: Colors.green,
                      fontSize: 14
                    ),)

                  ],
                ),
              ),
              Icon(Icons.more_vert,color: Colors.grey.shade700,)

            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(kToolbarHeight);
}