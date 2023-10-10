import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/main.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/features/core/screens/institutions/add_institution.dart';
import 'package:integritylink/src/features/core/screens/institutions/inst_model.dart';
import 'package:integritylink/src/features/core/screens/institutions/institution_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class InstitutionHome extends StatefulWidget {
  const InstitutionHome({Key? key}) : super(key: key);

  @override
  _InstitutionHomeState createState() => _InstitutionHomeState();
}

class _InstitutionHomeState extends State<InstitutionHome> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InstitutionController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Institutions",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInstitutionScreen(),
            ),
          );
        },
        child: Icon(
          LineAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(
              top: tDefaultSize, bottom: tDefaultSize, left: 10, right: 10),
          child: FutureBuilder<List<InstModel>>(
            future: controller.getSchools(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: List.generate(snapshot.data!.length, (index) {
                    return Column(
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          leading: snapshot.data![index].image != null &&
                                  snapshot.data![index].image
                                          .toString()
                                          .length >=
                                      1
                              ? SizedBox(
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
                                              child:
                                                  Icon(CupertinoIcons.person)),
                                    ),
                                  ),
                                )
                              : SizedBox(
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
                              text: snapshot.data![index].name,
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
                              LineAwesomeIcons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => UpdateProfileScreen(
                              //       user: snapshot.data![index],
                              //     ),
                              //   ),
                              // );

                              print(
                                snapshot.data![index].email,
                              );
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }),
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
}
