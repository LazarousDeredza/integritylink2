import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/constants/colors.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/constants/text_strings.dart';
import 'package:integritylink/src/features/core/screens/about/about_screen.dart';
import 'package:integritylink/src/features/core/screens/cases/admin/admin_cases_list.dart';
import 'package:integritylink/src/features/core/screens/data_screen/admin_section/admin_data.dart';
import 'package:integritylink/src/features/core/screens/education_screens/articles/admin/article_list_admin.dart';
import 'package:integritylink/src/features/core/screens/institutions/Institutions_list_home.dart';
import 'package:integritylink/src/features/core/screens/profile/admins.dart';
import 'package:integritylink/src/features/core/screens/profile/update_profile.dart';
import 'package:integritylink/src/repository/authentication_repository/authentication_repository.dart';
import 'package:integritylink/src/utils/theme/theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'users.dart';
import 'widgets/profile_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
//bool is admin
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();

    //get current logged in user level
    var level = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
        .get()
        .then((value) {
      if (value.data()!["level"] == "admin") {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    //get current logged in user email
    var email = AuthenticationRepository.instance.firebaseUser.value!.email;
    Get.put(FabIconController());

    return Scaffold(
      appBar: AppBar(
        title: Text(tProfile, style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
            onPressed: () {
              isDark = !isDark;

              // Update the theme using GetX
              Get.changeTheme(
                isDark ? TAppTheme.darkTheme : TAppTheme.lightTheme,
              );

              // Show a snackbar based on the updated theme
              Get.snackbar(
                'Theme Changed',
                isDark ? 'Dark Theme Enabled' : 'Light Theme Enabled',
                backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                colorText: isDark ? Colors.white : Colors.black,
              );

              // Update the icon based on the theme state
              Get.find<FabIconController>().updateIcon(isDark);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
                left: tDefaultSize,
                right: tDefaultSize,
                bottom: tDefaultSize,
                top: 8),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(tProfileImage),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: tPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => UpdateProfileScreen(),
                            );
                          },
                          child: const Icon(
                            LineAwesomeIcons.pen,
                            color: tDarkColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tProfileHeading,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  tProfileSubHeading,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(
                          () => UpdateProfileScreen(),
                        );
                      },
                      child: const Text(
                        "View Profile",
                        style: TextStyle(
                          color: tDarkColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 8),
                //menu

                ProfileMenuWidget(
                  title: tMenu3,
                  icon: LineAwesomeIcons.question_circle,
                  onPress: () {
                    Get.to(() => AboutScreen());
                  },
                ),
                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  Center(
                    child: Text("Adminstrative"),
                  ),
                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  ProfileMenuWidget(
                    title: "Comment Approvals",
                    icon: LineAwesomeIcons.bell,
                    onPress: () {
                      _showApprovalChooseDialogBottomSheet(context);
                    },
                  ),

                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  ProfileMenuWidget(
                    title: "Institutions",
                    icon: LineAwesomeIcons.school,
                    onPress: () {
                      if (email == "ninja.ld49@gmail.com" ||
                          email == "pamodzichildafrica@gmail.com" ||
                          email == "info@yc4integritybuilding.org" ||
                          email == "damarisaswa12@gmail.com" ||
                          email == "ken@yc4integritybuilding.org" ||
                          isAdmin) {
                        Get.to(() => InstitutionHome());
                      } else {
                        Get.snackbar(
                          "Permission Denied",
                          "",
                          icon: Icon(Icons.error),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  ProfileMenuWidget(
                    title: "Update Case",
                    icon: LineAwesomeIcons.edit,
                    onPress: () {
                      if (email == "ninja.ld49@gmail.com" ||
                          email == "pamodzichildafrica@gmail.com" ||
                          email == "info@yc4integritybuilding.org" ||
                          email == "damarisaswa12@gmail.com" ||
                          email == "ken@yc4integritybuilding.org" ||
                          isAdmin) {
                        Get.to(() => AdminCaseListScreen());
                      } else {
                        Get.snackbar(
                          "Permission Denied",
                          "",
                          icon: Icon(Icons.error),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  ProfileMenuWidget(
                    title: "Admins",
                    icon: LineAwesomeIcons.users,
                    onPress: () {
                      Get.to(() => AdminScreen());
                    },
                  ),
                if (email == "ninja.ld49@gmail.com" ||
                    email == "pamodzichildafrica@gmail.com" ||
                    email == "info@yc4integritybuilding.org" ||
                    email == "damarisaswa12@gmail.com" ||
                    email == "ken@yc4integritybuilding.org" ||
                    isAdmin)
                  ProfileMenuWidget(
                    title: "Users",
                    icon: LineAwesomeIcons.users,
                    onPress: () {
                      Get.to(() => UsersScreen());
                    },
                  ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 5),

                ProfileMenuWidget(
                  title: tMenu5,
                  icon: LineAwesomeIcons.alternate_sign_out,
                  onPress: () {
                    _showConfirmationBottomSheet(context);
                  },
                  endIcon: false,
                  textColor: Colors.red,
                ),
                const SizedBox(height: 35),
                const Divider(),
                SizedBox(
                  width: 150,
                  child: const Text(
                    "Version : 1.0.0",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontStyle: FontStyle.italic,
                      fontSize: 15.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                        // logout action
                        Navigator.pop(context);
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

  void _showApprovalChooseDialogBottomSheet(BuildContext context) {
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
                  'Choose Option',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Get.to(
                          () => AdminCaseListScreen(),
                        );
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Cases comments')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // logout action
                        Navigator.pop(context);
                        // Close the bottom sheet

                        //logout
                        Get.to(() => AdminDataScreen());
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Documents Comments')),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // logout action
                        Navigator.pop(context);
                        // Close the bottom sheet

                        //logout
                        Get.to(() => AdminArticleListScreen());
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Article Comments')),
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

class FabIconController extends GetxController {
  final _icon = LineAwesomeIcons.sun.obs;

  IconData get icon => _icon.value;

  void updateIcon(bool isDark) {
    _icon.value = isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon;
  }
}
