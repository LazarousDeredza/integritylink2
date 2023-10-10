import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/dashboard/dashboard.dart';
import 'package:integritylink/src/features/core/screens/education_screens/articles/article_screen.dart';
import 'package:integritylink/src/features/core/screens/education_screens/youtube_vidoes/screens/home_screen.dart';

class EducationDashboard extends StatelessWidget {
  const EducationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Education Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 150),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  "Sub Menu",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
            Row(
              children: [
                CardField(
                  size,
                  Colors.teal,
                  Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                  ),
                  'Education',
                  'Videos',
                  () {
                    Get.to(() => YoutubeScreen());
                  },
                ),
                CardField(
                  size,
                  Colors.teal,
                  Icon(
                    Icons.border_color_outlined,
                    color: Colors.white,
                  ),
                  'Education',
                  'Articles',
                  () {
                    Get.to(() => ArticleScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
