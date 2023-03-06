// ignore_for_file: unused_label, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text_stt/api_service.dart';
// import 'package:speech_to_text_stt/chat_model.dart';

import 'api_service.dart';
import 'chat_model.dart';
import 'colors.dart';

class Speechscreen extends StatefulWidget {
  const Speechscreen({Key? key}) : super(key: key);

  @override
  State<Speechscreen> createState() => _SpeechscreenState();
}

class _SpeechscreenState extends State<Speechscreen> {
  var text = "Hold the button and Start Speaking";
  var isListening = false;
  SpeechToText speechToText = SpeechToText();

  final List<Chat_Message> messages = [];

  var scrollcontroller = ScrollController();

  scrollMethod() {
    scrollcontroller.animateTo(scrollcontroller.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgcolor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        endRadius: 75.0,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              try {
                var available = await speechToText.initialize();
                if (available) {
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          // print("object6");
                          text = result.recognizedWords;
                        });
                      },
                    );
                  });
                }
              } catch (e) {
                print(e);
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
            print("stoping");

            messages.add(Chat_Message(text: text, type: Chat_MessageType.user));
            var msg = await ApiServices.generateResponse(text);

            setState(() {
              messages.add(Chat_Message(text: msg, type: Chat_MessageType.bot));
            });
          },
          child: CircleAvatar(
            backgroundColor: bgcolor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
          leading: const Icon(
            Icons.sort_rounded,
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: bgcolor,
          elevation: 0.0,
          title: const Text(
            "Voice Chat GPT",
            style: TextStyle(fontWeight: FontWeight.w600, color: textcolor),
          )),
      body: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.7,
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // margin: const EdgeInsets.only(bottom: 150),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 24,
                    color: isListening ? Colors.black87 : Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: chatbgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: scrollcontroller,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chat = messages[index];
                          return chatBubble(
                              chattext: chat.text, type: chat.type);
                        },
                      ))),
              SizedBox(
                height: 10,
              ),
              Text(
                "Developed by CBS",
                style: TextStyle(
                    fontSize: 24,
                    color: isListening
                        ? Color.fromARGB(221, 125, 116, 116)
                        : Color.fromARGB(137, 64, 63, 63),
                    fontWeight: FontWeight.w600),
              ),
            ],
          )),
    );
  }

  Widget chatBubble({required chattext, required Chat_MessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.black,
          child: type == Chat_MessageType.bot
              ? Image.asset('assets/chaticon.png')
              : Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: type == Chat_MessageType.bot ? bgcolor : Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Text(
              "$chattext",
              style: TextStyle(
                  color: type == Chat_MessageType.bot ? textcolor : chatbgColor,
                  fontSize: 15,
                  fontWeight: type == Chat_MessageType.bot
                      ? FontWeight.w600
                      : FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
