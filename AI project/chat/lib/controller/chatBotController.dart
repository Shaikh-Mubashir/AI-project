import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatBot {
  AuthGoogle authGoogle;
  List message = [];
  Future<void> initChatBot() async {
    authGoogle =
        await AuthGoogle(fileJson: 'assets/chat-c1f2d-419218f796d9.json')
            .build();
  }

  Future<String> getAnswerByChatBot(String query) async {
    try {
      print(query);
      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: 'assets/chat-c1f2d-419218f796d9.json')
              .build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);
      AIResponse aiResponse = await dialogflow.detectIntent(query);
      //AIResponse aiResponse= await dialogflow.
      // message.insert(0, {
      //   "data": 0,
      //   "message": aiResponse.getListMessage()[0]["text"]["text"].toString()
      // });
      print(aiResponse.getMessage());
      return aiResponse.getMessage();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
