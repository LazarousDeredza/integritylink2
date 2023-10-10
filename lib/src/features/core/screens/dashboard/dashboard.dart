import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/cases/cases_list.dart';
import 'package:integritylink/src/features/core/screens/cases/report_case.dart';
import 'package:integritylink/src/features/core/screens/data_screen/data.dart';
import 'package:integritylink/src/features/core/screens/education_screens/education_dashboard.dart';
import 'package:integritylink/src/features/core/screens/group_chat/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/pages/home_page.dart';
import 'package:integritylink/src/features/core/screens/personal_chat/screens/chat_home_screen.dart';
import 'package:integritylink/src/features/core/screens/profile/settings_screen.dart';

import '../../../../constants/colors.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Home",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // AuthenticationRepository.instance.logout();
                Get.to(() => SettingsScreen());
              },
              //three dots from font awesome
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xfff5f7fa),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * .35,
                  width: size.width,
                ),
                GradientContainer(size),
                Positioned(
                  top: size.height * .06,
                  left: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "IntegrityLink",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          "keep the public sector honest",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Rooms(),
                              //   ),
                              // ),
                              child: Container(
                                height: size.height * .15,
                                width: size.width * .4,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      "assets/bg.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      top: size.height * .12,
                                    ),
                                    child: const Text(
                                      'Stay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Rooms(),
                              //   ),
                              // ),
                              child: Container(
                                height: size.height * .15,
                                width: size.width * .4,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      "assets/bg.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      top: size.height * .12,
                                    ),
                                    child: const Text(
                                      'Connected',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DevicesGridDashboard(size: size),
                      ScenesDashboard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Container GradientContainer(Size size) {
    return Container(
      height: size.height * .3,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            gradient: LinearGradient(colors: [
              tPrimaryColor.withOpacity(0.9),
              primaryColor.withOpacity(0.9)
            ])),
      ),
    );
  }
}

class ScenesDashboard extends StatelessWidget {
  const ScenesDashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => SettingsScreen(),
                  );
                },
                child: CardWidget(
                    icon: Icon(
                      Icons.settings,
                      color: secondaryColor,
                    ),
                    title: 'Settings'),
              ),
              GestureDetector(
                onTap: () {
                  _showConfirmationBottomSheet(
                      context); // Show the bottom sheet on tap
                },
                child: CardWidget(
                    icon: Icon(
                      Icons.local_fire_department_outlined,
                      color: secondaryColor,
                    ),
                    title: 'Logout'),
              )
            ],
          ),
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
}

class CardWidget extends StatelessWidget {
  final Icon icon;
  final String title;

  CardWidget({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      child: SizedBox(
        height: 50,
        width: 150,
        child: Center(
          child: ListTile(
            leading: icon,
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class DevicesGridDashboard extends StatelessWidget {
  const DevicesGridDashboard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                size,
                Colors.blue,
                Icon(
                  Icons.report_problem_outlined,
                  color: Colors.white,
                ),
                'Report',
                'Cases',
                () {
                  Get.to(() => ReportCorruptionScreen());
                },
              ),
              CardField(
                size,
                Colors.amber,
                Icon(
                  Icons.track_changes_outlined,
                  color: Colors.white,
                ),
                'Case',
                'Tracking',
                () {
                  Get.to(() => CaseListScreen());
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                size,
                Colors.orange,
                Icon(
                  Icons.data_usage_outlined,
                  color: Colors.white,
                ),
                'Data',
                'Access',
                () {
                  Get.to(() => DataScreen());
                },
              ),
              CardField(
                size,
                Colors.teal,
                Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                ),
                'Education',
                'Resources',
                () {
                  Get.to(() => EducationDashboard());
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardField(
                  size,
                  Colors.purple,
                  Icon(
                    Icons.people_alt_outlined,
                    color: Colors.white,
                  ),
                  'Club',
                  'Network', () {
                _showClubChooseBottomSheet(
                    context); // Show the bottom sheet on tap
              }),
              CardField(
                  size,
                  Colors.green,
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.white,
                  ),
                  'User',
                  'Connect', () {
                Get.to(() => ChatHomePage());
              }),
            ],
          )
        ],
      ),
    );
  }

  void _showClubChooseBottomSheet(BuildContext context) {
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
                  'Choose a type of club',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Get.to(() => InstututionalHomeGroupScreen());
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text('Institutional')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //  Perform logout action
                        Navigator.pop(context);
                        // Close the bottom sheet

                        Get.to(
                          () => CommunityGroupHomePage(),
                        );
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text('Community')),
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

CardField(
  Size size,
  Color color,
  Icon icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Card(
      color: Colors.white.withOpacity(0.7),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: size.height * .1,
          width: size.width * .39,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: icon,
              ),
              title: Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
