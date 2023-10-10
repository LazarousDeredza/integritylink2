import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/cases/model_case.dart';
import 'package:integritylink/src/features/core/screens/cases/report_controller.dart';
import 'package:intl/intl.dart';

class ReportCorruptionScreen extends StatefulWidget {
  @override
  _ReportCorruptionScreenState createState() => _ReportCorruptionScreenState();
}

class _ReportCorruptionScreenState extends State<ReportCorruptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _personsInvolvedController = TextEditingController();
  final _supportingEvidenceController = TextEditingController();
  final _reportDetailsController = TextEditingController();
  final _onBehalfOfController = TextEditingController();
  final _awarenessDetailsController = TextEditingController();
  final _additionalEvidenceController = TextEditingController();
  final _additionalWitnessesController = TextEditingController();
  final _desiredOutcomeController = TextEditingController();
  final _reportingOutcomeController = TextEditingController();
  final _resolutionDetailsController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _personsInvolvedController.dispose();
    _supportingEvidenceController.dispose();
    _reportDetailsController.dispose();
    _onBehalfOfController.dispose();
    _awarenessDetailsController.dispose();
    _additionalEvidenceController.dispose();
    _additionalWitnessesController.dispose();
    _desiredOutcomeController.dispose();
    _reportingOutcomeController.dispose();
    _resolutionDetailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    userID = FirebaseAuth.instance.currentUser!.uid;
  }

  String? _onBehalfOf;
  String? _witnesses;
  DateTime? _selectedDate; // Variable to store the selected date
  List<String> urls = [];
  bool isUploading = false;

  String? userID;

  List<String> _selectedOffences = [];

  final List<String> _offencesList = [
    'Bribery of public officers and members of the Legislative Assembly',
    'Frauds on the Government',
    'Contractor subscribing to election fund',
    'Breach of trust by public officer or by a member of the Legislative Assembly',
    'Influencing or negotiating appointments or dealing in offices',
    'False claims by public officers',
    'Abuse of office',
    'False certificates by public officers or by members of the Legislative Assembly',
    'Conflicts of interest',
    'Duty of a public officer and member of the Legislative Assembly to whom a bride is offered',
    'False statements to the Commission',
    'Conspiracy, etc. to commit an offence under the Law',
    'Other'
  ];

  uploadDataToFirebase() async {
    // Pick image files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      dialogTitle: "Select Evidence",
    );

    // Show snackbar if no file is selected
    if (result == null || result.files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No File Selected"),
      ));
      return;
    } else if (result.files.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Maximum number of files exceeded (4)"),
      ));
      return;
    } else {
      setState(() {
        isUploading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Uploading File"),
      ));
    }

    //clear urls
    urls.clear();

    // Upload each file to Firebase Storage
    for (var file in result.files) {
      var path = file.path!;
      var bytes = await File(path).readAsBytes();
      String fileName = path.split('/').last;

      // Uploading file to Firebase Storage
      var reference =
          FirebaseStorage.instance.ref().child("evidences").child(fileName);
      UploadTask task = reference.putData(bytes);

      TaskSnapshot snapshot = await task;
      String fileUrl = await snapshot.ref.getDownloadURL();

      // Store the URL in the list
      urls.add(fileUrl);

      // Uploading URL to Firebase Firestore
      await FirebaseFirestore.instance.collection('evidences').add({
        'url': fileUrl,
        'name': fileName,
      });
    }

    // Snackbar to indicate file upload completion
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Files Uploaded"),
    ));
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller2 = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Corruption'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode.always, // Always validate the form

            child: Stack(
              children: [
                if (isUploading) LinearProgressIndicator(),
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    if (isUploading)
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Center(
                              child: Text(
                                "Uploading Evidence...",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          LinearProgressIndicator(),
                        ],
                      ),

                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Where did the incident occur?',
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter the location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selectDateTime(context);
                      },
                      child: TextFormField(
                        controller: _dateController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Date of incident (dd/mm/yyyy)',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDateTime(context);
                            },
                          ),
                        ),
                        // put a calendar icon here

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the date';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // You can parse and store the date as needed
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Offences checkboxes
                    Text(
                      'I believe or suspect the following offences (check all that apply) under the Anti-Corruption Law have been committed:',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      children: _offencesList
                          .map((offence) => CheckboxListTile(
                                title: Text(
                                  offence,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                value: _selectedOffences.contains(offence),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value!) {
                                      _selectedOffences.add(offence);
                                    } else {
                                      _selectedOffences.remove(offence);
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: _personsInvolvedController,
                      decoration: InputDecoration(
                        labelText: 'Person(s) involved',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the person(s) involved';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _supportingEvidenceController,
                      decoration: InputDecoration(
                        labelText: 'Supporting Evidence Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide supporting evidence';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Please attach any supporting evidence (max 4 images)',
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print("IsUploading = true");

                        setState(() {
                          isUploading =
                              true; // Set isUploading to true before uploading
                        });

                        // Call the uploadDataToFirebase() method
                        await uploadDataToFirebase();

                        setState(() {
                          isUploading =
                              false; // Set isUploading to false after uploading
                        });

                        print("Isuploading = false ");
                      },
                      child: Text("Attach"),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _reportDetailsController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Report Details',
                        border: OutlineInputBorder(
                          // Added border to the text field
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the report details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Are you making this report/complaint on behalf of someone else?',
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Radio(
                          value: 'YES',
                          groupValue: _onBehalfOf,
                          onChanged: (value) {
                            setState(() {
                              _onBehalfOf = value as String?;
                              if (_onBehalfOf == 'YES') {
                                _awarenessDetailsController.text = "";
                              }
                            });
                          },
                        ),
                        Text('YES'),
                        SizedBox(width: 16.0),
                        Radio(
                          value: 'NO',
                          groupValue: _onBehalfOf,
                          onChanged: (value) {
                            setState(() {
                              _onBehalfOf = value as String?;
                              if (_onBehalfOf == 'NO') {
                                _awarenessDetailsController.text = "N/A";
                              }
                            });
                          },
                        ),
                        Text('NO'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    if (_onBehalfOf == 'YES')
                      Text(
                          "How and when did you become aware of the incident?"),
                    if (_onBehalfOf == 'YES')
                      TextFormField(
                        maxLines: null,
                        controller: _awarenessDetailsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            // Added border to the text field
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide details';
                          }
                          return null;
                        },
                      ),

                    SizedBox(height: 16.0),
                    Text(
                        "If you believe there is additional evidence, describe it"),
                    TextFormField(
                      maxLines: null,
                      controller: _additionalEvidenceController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          // Added border to the text field
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                        "Are there any other people who may be aware of this matter and may be able to assist in investigating it ?"),

                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Radio(
                          value: 'YES',
                          groupValue: _witnesses,
                          onChanged: (value) {
                            setState(() {
                              _witnesses = value as String?;
                              if (_witnesses == 'YES') {
                                _additionalWitnessesController.text = "";
                              }
                            });
                          },
                        ),
                        Text('YES'),
                        SizedBox(width: 16.0),
                        Radio(
                          value: 'NO',
                          groupValue: _witnesses,
                          onChanged: (value) {
                            setState(() {
                              _witnesses = value as String?;
                              if (_witnesses == 'NO') {
                                _additionalWitnessesController.text = "None";
                              }
                            });
                          },
                        ),
                        Text('NO'),
                      ],
                    ),

                    SizedBox(height: 8.0),
                    if (_witnesses == 'YES')
                      Text(
                          "Who are they and how may they be contacted? N.B This information will be kept confidential."),

                    SizedBox(height: 8.0),
                    if (_witnesses == 'YES')
                      TextFormField(
                        maxLines: null,
                        controller: _additionalWitnessesController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            // Added border to the text field
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide details';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 16.0),
                    Text(
                        "What do you want to happen as a result of making this report/complaint?"),
                    TextFormField(
                      maxLines: null,
                      controller: _desiredOutcomeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          // Added border to the text field
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                        'Have you reported, or complained about, this matter to any other person or agency? If so, to whom or to which agency? What was the outcome? Please attach any relevant correspondence.'),
                    TextFormField(
                      maxLines: null,
                      controller: _reportingOutcomeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          // Added border to the text field
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                        'Have you tried to resolve this matter in any other way? If yes, please give details.'),
                    TextFormField(
                      maxLines: null,
                      controller: _resolutionDetailsController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          // Added border to the text field
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: isUploading
                          ? () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Please wait for Evidence upload to finish"),
                              ));
                            }
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Process the form data

                                CaseModel caseModel = CaseModel(
                                  dateReported: _formatDateTime(
                                      DateTime.now().toString()),
                                  status: "Open",
                                  howItWasResolved: "",
                                  caseID: generateRandomString(),
                                  reportedBy: userID,
                                  witnesses: _witnesses,
                                  comments: [],
                                  location: _locationController.text,
                                  dateCommitted: _dateController.text,
                                  personsInvolved:
                                      _personsInvolvedController.text,
                                  supportingEvidence:
                                      _supportingEvidenceController.text,
                                  reportDetails: _reportDetailsController.text,
                                  onBehalfOf: _onBehalfOf.toString(),
                                  awarenessDetails:
                                      _awarenessDetailsController.text,
                                  additionalEvidence:
                                      _additionalEvidenceController.text,
                                  additionalWitnesses:
                                      _additionalWitnessesController.text,
                                  desiredOutcome:
                                      _desiredOutcomeController.text,
                                  reportingOutcome:
                                      _reportingOutcomeController.text,
                                  resolutionDetails:
                                      _resolutionDetailsController.text,
                                  selectedOffences: _selectedOffences,
                                  evidenceUrl: urls,
                                );

                                print(caseModel.toJson());
                                controller2.saveCase(
                                  caseModel,
                                  generateRandomString(),
                                );
                                wipeData();
                                //Get.to(() => ReportCorruptionScreen());
                              }
                            },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDateTime;
          final formattedDate =
              DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!);
          _dateController.text = formattedDate;
        });
      }
    }
  }

  static String _formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  static String generateRandomString() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String randomString = '';

    for (var i = 0; i < 6; i++) {
      final randomIndex = random.nextInt(chars.length);
      randomString += chars[randomIndex];
    }

    print("generated code id $randomString");

    return randomString;
  }

  void wipeData() {
    _locationController.clear();
    _dateController.clear();
    _personsInvolvedController.clear();
    _supportingEvidenceController.clear();
    _reportDetailsController.clear();
    _onBehalfOfController.clear();
    _awarenessDetailsController.clear();
    _additionalEvidenceController.clear();
    _additionalWitnessesController.clear();
    _desiredOutcomeController.clear();
    _reportingOutcomeController.clear();
    _resolutionDetailsController.clear();
    _selectedOffences.clear();
    urls.clear();
  }
}
