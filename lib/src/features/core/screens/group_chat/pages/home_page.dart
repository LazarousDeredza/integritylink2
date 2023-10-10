import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/dashboard/dashboard.dart';
import 'package:integritylink/src/features/core/screens/group_chat/helper/helper_function.dart';
import 'package:integritylink/src/features/core/screens/group_chat/pages/search_page.dart';
import 'package:integritylink/src/features/core/screens/group_chat/service/auth_service.dart';
import 'package:integritylink/src/features/core/screens/group_chat/service/database_service.dart';
import 'package:integritylink/src/features/core/screens/group_chat/widgets/group_tile.dart';
import 'package:integritylink/src/features/core/screens/group_chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/profile/update_profile.dart';
import 'package:integritylink/src/repository/authentication_repository/authentication_repository.dart';

class CommunityGroupHomePage extends StatefulWidget {
  const CommunityGroupHomePage({Key? key}) : super(key: key);

  @override
  State<CommunityGroupHomePage> createState() => _CommunityGroupHomePageState();
}

class _CommunityGroupHomePageState extends State<CommunityGroupHomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await CommunityGroupHelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
        print('Email' + email);
      });
    });
    await CommunityGroupHelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        print('Username' + userName);
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      print("Uid >>" + FirebaseAuth.instance.currentUser!.uid);
      print("snapshop" + snapshot.toString());
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => Dashboard(),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(
                  Icons.search,
                ))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Community Clubs",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        drawer: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 56),
            child: Drawer(
                width: 230,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    ListTile(
                      onTap: () {
                        //close drawer
                        Navigator.pop(context);
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      selected: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        "Community Clubs",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        //close drawer
                        Navigator.pop(context);
                        Get.to(() => InstututionalHomeGroupScreen());
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      selected: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        "Institutional Clubs",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      onTap: () {
                        // nextScreenReplace(
                        //   context,
                        //   ProfilePage(
                        //     userName: userName,
                        //     email: email,
                        //   ),
                        // );
                        //close drawer
                        Navigator.pop(context);
                        Get.to(() => UpdateProfileScreen());
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Profile",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        // showDialog(
                        //     barrierDismissible: false,
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: const Text("Logout"),
                        //         content: const Text("Are you sure you want to logout?"),
                        //         actions: [
                        //           IconButton(
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //             icon: const Icon(
                        //               Icons.cancel,
                        //               color: Colors.red,
                        //             ),
                        //           ),
                        //           IconButton(
                        //             onPressed: () async {
                        //               await authService.signOut();
                        //               Navigator.of(context).pushAndRemoveUntil(
                        //                   MaterialPageRoute(
                        //                       builder: (context) => const LoginPage()),
                        //                   (route) => false);
                        //             },
                        //             icon: const Icon(
                        //               Icons.done,
                        //               color: Colors.green,
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     });

                        //close drawer
                        Navigator.pop(context);
                        _showConfirmationBottomSheet(context);
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.exit_to_app),
                      title: Text(
                        "Logout",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )),
          ),
        ),
        body: groupList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a club",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: InputDecoration(
                              hintText: 'Club name',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    "CANCEL",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                //space
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    "CREATE",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['name']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any clubs, tap on the add icon to create a club or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //  Perform logout action
                        // Navigator.pop(context);
                        // Close the bottom sheet

                        //logout
                        AuthenticationRepository.instance.logout();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
