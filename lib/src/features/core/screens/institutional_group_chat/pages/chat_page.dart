import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/service/database_service.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/widgets/message_tile.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/widgets/widgets.dart';

import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _showFloatingArrow;
  bool _isTyping = false;

  @override
  void initState() {
    getChatandAdmin();

    super.initState();

    _showFloatingArrow = ValueNotifier<bool>(false);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - 300) {
      _showFloatingArrow.value = false;
      print("bottom of page");
    } else if (_scrollController.offset <=
        _scrollController.position.minScrollExtent) {
      _showFloatingArrow.value = true;
      print("top of page");
    } else {
      _showFloatingArrow.value = true;
      print("show arrow: else");
    }
  }

  void _handleTextChange(String value) {
    setState(() {
      _isTyping = value.isNotEmpty;
    });
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    print("Get chats");

    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
    print("Get group admin");
  }

  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(widget.groupName),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      nextScreen(
                          context,
                          GroupInfo(
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                            adminName: admin,
                          ));
                    },
                    icon: const Icon(Icons.info))
              ],
            ),
            body: Column(
              children: [
                // chat messages here

                chatMessages(),

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     alignment: Alignment.bottomCenter,
                //     width: MediaQuery.of(context).size.width,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 20, vertical: 10),
                //       width: MediaQuery.of(context).size.width,
                //       // color: Colors.grey[700],
                //       child: Row(
                //         children: [
                //           //input field & buttons
                //           Expanded(
                //             child: Card(
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(15)),
                //               child: Row(
                //                 children: [
                //                   //emoji button
                //                   IconButton(
                //                     onPressed: () {
                //                       FocusScope.of(context).unfocus();
                //                       setState(() => _showEmoji = !_showEmoji);
                //                     },
                //                     icon: const Icon(Icons.emoji_emotions,
                //                         color: Colors.blueAccent, size: 25),
                //                   ),

                //                   Expanded(
                //                     child: TextField(
                //                       onChanged: _handleTextChange,
                //                       maxLines: null,
                //                       controller: messageController,
                //                       keyboardType: TextInputType.multiline,
                //                       onTap: () {
                //                         if (_showEmoji)
                //                           setState(
                //                               () => _showEmoji = !_showEmoji);
                //                       },
                //                       decoration: const InputDecoration(
                //                         hintText: 'Type a message...',
                //                         hintStyle:
                //                             TextStyle(color: Colors.blueAccent),
                //                         border: InputBorder.none,
                //                         focusedBorder: InputBorder.none,
                //                         enabledBorder: InputBorder.none,
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),

                //           //send message button
                //           MaterialButton(
                //             onPressed: () {
                //               sendMessage();
                //             },
                //             minWidth: 0,
                //             padding: const EdgeInsets.only(
                //                 top: 10, bottom: 10, right: 5, left: 10),
                //             shape: const CircleBorder(),
                //             color: Colors.green,
                //             child: const Icon(Icons.send,
                //                 color: Colors.white, size: 28),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                _chatInput(),

                if (_showEmoji)
                  SizedBox(
                      height: mq.height * .35,
                      //........
                      child: Container(
                        color: Colors.white,
                        child: EmojiPicker(
                          textEditingController: messageController,
                          config: Config(
                            bgColor: const Color.fromARGB(255, 234, 248, 255),
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            time: snapshot.data.docs[index]['time'],
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: widget.userName ==
                                snapshot.data.docs[index]['sender'],
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _showFloatingArrow,
                      builder: (context, value, child) {
                        return value && !_isTyping
                            ? Positioned(
                                //bottom: 100,
                                right: 20,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                    _showFloatingArrow.value = false;
                                  },
                                  child: Icon(Icons.arrow_downward),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 25),
                  ),

                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
