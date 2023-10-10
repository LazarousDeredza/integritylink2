import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:integritylink/src/features/core/screens/data_screen/document_comments_screen.dart';
import 'package:integritylink/src/features/core/screens/group_chat/widgets/widgets.dart';
import 'package:integritylink/src/repository/authentication_repository/authentication_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class DataListScreen extends StatefulWidget {
  const DataListScreen({Key? key, required this.dataType});
  final String dataType;

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  String url = '';

  String get typeOfDocument => widget.dataType;

  uploadDataToFirebase() async {
    //pick pdf file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'png',
        'jpg',
        'jpeg',
        'xls',
        'xlsx',
        'xlsm',
        'xlsb',
        'ppt',
        'pptx',
        'pptm',
        'potx',
        'csv',
      ],
      allowCompression: true,
      dialogTitle: 'Select Document',
    );

//show snackbar if no file is selected
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No File Selected"),
      ));
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Uploading File"),
      ));
    }

    File pick = File(result.files.single.path.toString());
    var file = pick.readAsBytesSync();
    String fileName = pick.path.split('/').last;
    String extension = pick.path.split('.').last;
    String fileSize = (pick.lengthSync() / 1024 / 1024).toStringAsFixed(2);
    List<String> comments = [];
    //uploading file to firebase storage
    var pdfFile = await FirebaseStorage.instance
        .ref()
        .child(typeOfDocument)
        .child(fileName);
    UploadTask task = pdfFile.putData(file);

    TaskSnapshot snapshotTask = await task;
    url = await snapshotTask.ref.getDownloadURL();

    //uploading url to firebase firestore
    await FirebaseFirestore.instance.collection(typeOfDocument).add({
      'url': url,
      'name': fileName,
      'extension': extension.toLowerCase(),
      'size': fileSize,
      'comments': comments,
    }).whenComplete(() => () {
          //snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("File Uploaded"),
          ));
        });
  }

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
    var email = AuthenticationRepository.instance.firebaseUser.value!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(typeOfDocument),
      ),
      floatingActionButton: email == "ninja.ld49@gmail.com" ||
              email == "pamodzichildafrica@gmail.com" ||
              email == "info@yc4integritybuilding.org" ||
              email == "damarisaswa12@gmail.com" ||
              email == "ken@yc4integritybuilding.org" ||
              isAdmin
          ? FloatingActionButton(
              onPressed: uploadDataToFirebase,
              child: Icon(Icons.add),
            )
          : null,
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(typeOfDocument).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[i];

                  return InkWell(
                    onTap: () {
                      if (x['extension'] == 'pdf') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfViewer(
                                      url: x['url'],
                                    )));
                      } else {
                        showSnackbar(
                          context,
                          Colors.greenAccent,
                          "Loading File\nPlease Wait ...",
                        );

                        FirebaseStorage.instance
                            .refFromURL(x['url'])
                            .getData()
                            .then((value) async {
                          final directory = await getExternalStorageDirectory();

                          final downloadsPath = '${directory!.path}/Download';
                          final filePath = '$downloadsPath/${x['name']}';

                          if (!await Directory(downloadsPath).exists()) {
                            await Directory(downloadsPath)
                                .create(recursive: true);
                          }

                          File file = File(filePath);

                          _saveFile2(file, value!);
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          // image depending on extension
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: x['extension'] == 'pdf' ||
                                    x['extension'] == 'PDF' ||
                                    x['extension'] == 'Pdf' ||
                                    x['extension'] == 'pDF'
                                ? Image.asset(
                                    'assets/images/file_icons/pdf.png',
                                    height: 30.0,
                                    width: 30.0,
                                  )
                                : x['extension'] == 'docx' ||
                                        x['extension'] == 'doc'
                                    ? Image.asset(
                                        'assets/images/file_icons/docx.png',
                                        height: 30.0,
                                        width: 30.0,
                                      )
                                    : x['extension'] == 'png' ||
                                            x['extension'] == 'jpg' ||
                                            x['extension'] == 'jpeg'
                                        ? Image.asset(
                                            'assets/images/file_icons/image.png',
                                            height: 30.0,
                                            width: 30.0,
                                          )
                                        : x['extension'] == 'xlsx' ||
                                                x['extension'] == 'xls' ||
                                                x['extension'] == 'xlsm' ||
                                                x['extension'] == 'xlsb'
                                            ? Image.asset(
                                                'assets/images/file_icons/excel.png',
                                                height: 30.0,
                                                width: 30.0,
                                              )
                                            : x['extension'] == 'csv' ||
                                                    x['extension'] == 'txt'
                                                ? Image.asset(
                                                    'assets/images/file_icons/text.png',
                                                    height: 30.0,
                                                    width: 30.0,
                                                  )
                                                : x['extension'] == 'ppt' ||
                                                        x['extension'] ==
                                                            'pptx' ||
                                                        x['extension'] ==
                                                            'pptm' ||
                                                        x['extension'] == 'potx'
                                                    ? Image.asset(
                                                        'assets/images/file_icons/ppt.png',
                                                        height: 30.0,
                                                        width: 30.0,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/file_icons/file.png',
                                                        height: 30.0,
                                                        width: 30.0,
                                                      ),
                          ),

                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    x['name'],
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        x['size'] + ' MB',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),

                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DocumentCommentsScreen(
                                                        id: x.id,
                                                      )));
                                        },
                                        child: Text("| Comments")),
                                    //comment icon in a stack
                                    // with number of comments on top
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DocumentCommentsScreen(
                                                      id: x.id,
                                                    )));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('document_comments')
                                              .where('docID', isEqualTo: x.id)
                                              .where('approved',
                                                  isEqualTo: 'Yes')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              QuerySnapshot commentSnapshot =
                                                  snapshot.data
                                                      as QuerySnapshot;
                                              List<QueryDocumentSnapshot>
                                                  comments =
                                                  commentSnapshot.docs;

                                              return Stack(
                                                children: [
                                                  Icon(
                                                    Icons.message,
                                                    size: 30.0,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                        minWidth: 15.0,
                                                        minHeight: 15.0,
                                                      ),
                                                      child: Text(
                                                        comments.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Stack(
                                                children: [
                                                  Icon(
                                                    Icons.message,
                                                    size: 30.0,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                        minWidth: 15.0,
                                                        minHeight: 15.0,
                                                      ),
                                                      child: Text(
                                                        "0",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //download icon
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: IconButton(
                              onPressed: () {
                                //download file
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Downloading File"),
                                ));
                                // ...

// ...

// ...

                                FirebaseStorage.instance
                                    .refFromURL(x['url'])
                                    .getData()
                                    .then((value) async {
                                  final directory =
                                      await getExternalStorageDirectory();

                                  final downloadsPath =
                                      '${directory!.path}/Download';
                                  final filePath =
                                      '$downloadsPath/${x['name']}';

                                  if (!await Directory(downloadsPath)
                                      .exists()) {
                                    await Directory(downloadsPath)
                                        .create(recursive: true);
                                  }

                                  File file = File(filePath);

                                  if (await file.exists()) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('File Exists'),
                                          content: Text(
                                              'The file already exists. Do you want to overwrite it?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Overwrite'),
                                              onPressed: () {
                                                _saveFile(file, value!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    _saveFile(file, value!);
                                  }
                                });

// ...
                              },
                              icon: Icon(Icons.download),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("No Data found"),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

// Function to launch the file using url_launcher
  void _launchFile(String filePath) async {
    if (await canLaunch(filePath)) {
      await launch(filePath);
    } else {
      throw 'Could not launch $filePath';
    }
  }

// Function to save the file using path_provider

  void _saveFile(File file, List<int> value) async {
    await file.writeAsBytes(value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Downloaded'),
          content: Text('Do you want to open the file?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open File'),
              onPressed: () {
                OpenFile.open(file.path);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveFile2(File file, List<int> value) async {
    await file.writeAsBytes(value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Loaded'),
          content: Text('Do you want to open the file?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open File'),
              onPressed: () {
                OpenFile.open(file.path);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to open the file using open_file package
  void _openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    print(result.message);
  }
}

class PdfViewer extends StatelessWidget {
  final String url;
  static PdfViewerController? _pdfViewerController;

  const PdfViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF View")),
      body: SfPdfViewer.network(url, controller: _pdfViewerController),
    );
  }
}
