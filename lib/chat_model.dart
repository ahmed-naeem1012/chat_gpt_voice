// ignore_for_file: camel_case_types

enum Chat_MessageType{ user, bot }



class Chat_Message{
  Chat_Message({required this.text, required this.type});

  String? text;
  Chat_MessageType? type;
}