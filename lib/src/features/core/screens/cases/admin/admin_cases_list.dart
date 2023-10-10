import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integritylink/src/features/core/screens/cases/admin/admin_view_case.dart';
import 'package:integritylink/src/features/core/screens/cases/report_case.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/widgets/widgets.dart';

class AdminCaseListScreen extends StatefulWidget {
  const AdminCaseListScreen({Key? key}) : super(key: key);

  @override
  State<AdminCaseListScreen> createState() => _AdminCaseListScreenState();
}

class _AdminCaseListScreenState extends State<AdminCaseListScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String howItWasresolved = "";
  String id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search here...',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            //clear icon
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              id = value;
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportCorruptionScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cases').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final filteredCases = snapshot.data!.docs.where((x) {
              final selectedOffences =
                  (x['selectedOffences'] as List<dynamic>).join(', ');

              final caseId = x.id.toLowerCase() +
                  x['location'].toLowerCase() +
                  x['reportDetails'].toLowerCase() +
                  x['personsInvolved'].toLowerCase() +
                  x['dateCommitted'].toLowerCase() +
                  x['status'].toLowerCase() +
                  x['howItWasResolved'].toLowerCase() +
                  x['dateReported'].toLowerCase() +
                  x['reportedBy'].toLowerCase() +
                  x['caseID'].toLowerCase() +
                  x['onBehalfOf'].toLowerCase() +
                  x['awarenessDetails'].toLowerCase();
              final searchQuery = _searchController.text.toLowerCase();
              return caseId.contains(searchQuery) ||
                  selectedOffences.toLowerCase().contains(searchQuery);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        filteredCases.any((x) => x['status'] == "Open")
                            ? Icons.pending
                            : Icons.check_circle,
                        color: filteredCases.any((x) => x['status'] == "Open")
                            ? Colors.yellow
                            : Colors.green,
                        size: 35.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        filteredCases.any((x) => x['status'] == "Open")
                            ? "Open Cases"
                            : "Resolved Cases",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCases.length,
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot x = filteredCases[i];

                      return InkWell(
                        onTap: () {
                          print("Case ID = " + x.id);
                          // Go to view case screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminViewCaseScreen(caseId: x.id),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              leading: x['status'] == "Open"
                                  ? Icon(
                                      Icons.pending,
                                      color: Colors.yellow,
                                      size: 35.0,
                                    )
                                  : Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 35.0,
                                    ),
                              title: Text.rich(
                                TextSpan(
                                  text: x['location'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " - " + x['dateCommitted'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    x['reportDetails'],
                                    textAlign: TextAlign.justify,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final textSpan = TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 20.0,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5.0),
                                          ),
                                          TextSpan(
                                            text: x['personsInvolved'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      );

                                      return RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: textSpan,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Add your code for editing here
                                      id = x.id;
                                      print("Case ID = " + x.id);
                                      popUpDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 35.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("No Data found"),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

// IconButton(
//                                 onPressed: () {
//                                   showSnackbar(context, Colors.red,
//                                       "Deleting Please wait");

//                                   FirebaseFirestore.instance
//                                       .collection('cases')
//                                       .doc(x.id)
//                                       .delete()
//                                       .whenComplete(() {
//                                     Get.snackbar(
//                                       "Success",
//                                       "Case Deleted",
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       backgroundColor: Colors.green,
//                                       colorText: Colors.white,
//                                     );
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                               ),

  //  child: Container(
  //                     margin: EdgeInsets.symmetric(vertical: 10.0),
  //                     child: Row(
  //                       children: [
  //                         //pdf image
  //                         Container(
  //                           height: 70.0,
  //                           width: 70.0,
  //                           decoration: BoxDecoration(
  //                             image: DecorationImage(
  //                               image: AssetImage('assets/images/pdf.png'),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Container(
  //                             margin: EdgeInsets.symmetric(horizontal: 10.0),
  //                             child: Text(
  //                               x['location'],
  //                               style: TextStyle(fontSize: 17.0),
  //                             ),
  //                           ),
  //                         ),
  //                         IconButton(
  //                           onPressed: () {
  //                             // FirebaseFirestore.instance
  //                             //     .collection('articles')
  //                             //     .doc(x.id)
  //                             //     .delete();
  //                           },
  //                           icon: Icon(Icons.edit),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Enter How the case was resolved",
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
                              howItWasresolved = val;
                            });
                          },
                          maxLines: 5,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: InputDecoration(
                              hintText: 'Type here...',
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
                    if (howItWasresolved != "") {
                      setState(() {
                        _isLoading = true;
                      });

                      await FirebaseFirestore.instance
                          .collection('cases')
                          .doc(id)
                          .update({
                        'status': "Closed",
                        'howItWasResolved': howItWasresolved
                      });

                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Case Updated successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              ],
            );
          }));
        });
  }
}
