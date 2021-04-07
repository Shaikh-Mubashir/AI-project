import 'package:flutter/cupertino.dart';

import '../chatDetailPage.dart';

class ChatMessage{
  String Messages;
  bool isMe;
  String dateTime,type;
  ChatMessage({@required this.Messages, this.isMe,this.dateTime,this.type });
}