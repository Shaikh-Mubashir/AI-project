import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatBot{

  AuthGoogle authGoogle;
  List message=[];
  Future<void> initChatBot()async{
     authGoogle= await  AuthGoogle(
      fileJson: 'assets/expanded-idiom-310815-5cfd1fb308a1.json'
    ).build();
  }


  Future<void> getAnswerByChatBot(String query)async{
print(query);
AuthGoogle authGoogle= await  AuthGoogle(
    fileJson: 'assets/expanded-idiom-310815-5cfd1fb308a1.json'
).build();
    Dialogflow dialogflow= Dialogflow(authGoogle: authGoogle,language:Language.english);
   AIResponse aiResponse= await dialogflow.detectIntent('Will you marry me?');
    //AIResponse aiResponse= await dialogflow.
    message.insert(0, {
      "data":0,
      "message":aiResponse.getListMessage()[0]["text"]["text"].toString()
    });
    print(message);
  }
}