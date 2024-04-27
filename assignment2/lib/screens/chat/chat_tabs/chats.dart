import 'package:assignment2/const_config/text_config.dart';
import 'package:assignment2/widgets/chat_bubble.dart';
import 'package:assignment2/widgets/custom_buttons/Rouded_Action_Button.dart';
import 'package:assignment2/widgets/input_widgets/simple_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../const_config/color_config.dart';
import '../../../services/chat_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.scaffoldColor,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firebase.collection('chat').orderBy('time',descending: true).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                    var data = snapshot.data.docs;
                    return data.length != 0
                        ? ListView.builder(
                            itemCount: data.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return ChatBubble(
                                  message: data[index]['message'],
                                  isOwner: data[index]['uuid'].toString().compareTo(auth.currentUser!.uid.toString()) == 0,
                              );

                            },
                          )
                        : const Center(child: Text("No Chats to show"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Flexible(child: SimpleInputField(
                    controller: messageController,
                    hintText: "Message",
                    needValidation: true,
                    errorMessage: "Message box can't be empty",
                    fieldTitle: "",
                    needTitle: false,
                  ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: (){
                        if(messageController.text.isNotEmpty){
                          ChatService().sendChatMessage(message:messageController.text);
                          messageController.clear();
                        }
                      },
                      icon: const Icon(Icons.send)
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}


