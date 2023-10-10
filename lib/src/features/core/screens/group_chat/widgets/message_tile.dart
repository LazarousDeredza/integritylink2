import 'package:flutter/material.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/helper/my_date_util.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final int time;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.time,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.sentByMe ? Colors.lightGreen : Colors.lightBlue,
            width: 1,
          ),
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe
              ? const Color.fromARGB(255, 218, 255, 176)
              : const Color.fromARGB(255, 221, 245, 255),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.time.toString(),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}
