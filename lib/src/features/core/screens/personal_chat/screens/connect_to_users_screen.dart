import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/api/apis.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/helper/dialogs.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/features/authentication/models/user_model.dart';
import 'package:integritylink/src/features/core/controllers/profile_controller.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/models/chat_user.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/screens/chat_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ChatUsersScreen extends StatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Users",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.arrow_left,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () {
              _addChatUserDialog();
            },
            child: const Icon(Icons.add_comment_rounded)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: tDefaultSize, bottom: tDefaultSize, left: 10, right: 10),
          child: FutureBuilder<List<UserModel>>(
            future: controller.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: (() async {
                            await APIs.addChatUser(snapshot.data![index].email)
                                .then((value) {
                              print("Opening Conver");
                              ChatUser user = ChatUser(
                                email: snapshot.data![index].email,
                                firstName: snapshot.data![index].firstName,
                                lastName: snapshot.data![index].lastName,
                                phoneNo: snapshot.data![index].phoneNo,
                                image: snapshot.data![index].image ?? '',
                                about: snapshot.data![index].about,
                                createdAt:
                                    snapshot.data![index].createdAt ?? '',
                                groups: snapshot.data![index].groups ?? [],
                                id: snapshot.data![index].id ?? '',
                                isOnline: snapshot.data![index].isOnline,
                                lastActive: snapshot.data![index].lastActive,
                                level: snapshot.data![index].level ?? '',
                                name: snapshot.data![index].name,
                                pushToken: snapshot.data![index].pushToken,
                              );

                              Get.to(
                                () => ChatScreen(
                                  user: user,
                                ),
                              );
                            });
                            print(
                              snapshot.data![index].email,
                            );
                          }),
                          child: ListTile(
                            shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                10),
                            leading: snapshot.data![index].image != null &&
                                    snapshot.data![index].image
                                            .toString()
                                            .length >=
                                        1
                                ?
                                //image from server
                                SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: snapshot.data![index].image
                                            .toString(),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                child: Icon(
                                                    CupertinoIcons.person)),
                                      ),
                                    ),
                                  )
                                :
                                //local image
                                SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: Image(
                                          image: AssetImage(tProfileImage),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                            title: Text.rich(
                              TextSpan(
                                text: snapshot.data![index].firstName +
                                    " " +
                                    snapshot.data![index].lastName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].email,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].phoneNo != "null"
                                      ? snapshot.data![index].phoneNo
                                      : "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.message_rounded,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => UpdateProfileScreen(
                                //       user: snapshot.data![index],
                                //     ),
                                //   ),
                                // );

                                await APIs.addChatUser(
                                        snapshot.data![index].email)
                                    .then((value) {
                                  print("Opening Conver");
                                  ChatUser user = ChatUser(
                                    email: snapshot.data![index].email,
                                    firstName: snapshot.data![index].firstName,
                                    lastName: snapshot.data![index].lastName,
                                    phoneNo: snapshot.data![index].phoneNo,
                                    image: snapshot.data![index].image ?? '',
                                    about: snapshot.data![index].about,
                                    createdAt:
                                        snapshot.data![index].createdAt ?? '',
                                    groups: snapshot.data![index].groups ?? [],
                                    id: snapshot.data![index].id ?? '',
                                    isOnline: snapshot.data![index].isOnline,
                                    lastActive:
                                        snapshot.data![index].lastActive,
                                    level: snapshot.data![index].level ?? '',
                                    name: snapshot.data![index].name,
                                    pushToken: snapshot.data![index].pushToken,
                                  );

                                  Get.to(
                                    () => ChatScreen(
                                      user: user,
                                    ),
                                  );
                                });
                                print(
                                  snapshot.data![index].email,
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email ID',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
