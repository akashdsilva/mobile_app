import 'package:assignment2/const_config/color_config.dart';
import 'package:assignment2/const_config/text_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isOwner;
  final TextStyle? textStyle;

  const ChatBubble({super.key,
    required this.message,
    required this.isOwner,
    this.textStyle});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    return Row(
      mainAxisAlignment: widget.isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [

        if (!widget.isOwner) // Show avatar only for non-owners
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RandomAvatar(
              "7", // You can replace "avatar_key" with any unique identifier for the avatar
              trBackground: false,
              height: 30, // Adjust height as needed
              width: 30, // Adjust width as needed
            ),
          ),

        Align(
          child: Padding(
            padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              right: widget.isOwner ? 0 : 25,
              left: widget.isOwner ? 25 : 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isOwner ? MyColor.white : MyColor.primary,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.message,
                style: TextDesign().bodyTextSmall.copyWith(
                    color: widget.isOwner ? MyColor.black : MyColor.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}