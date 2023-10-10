import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/common_widgets/form/form_header_widget.dart';
import 'package:integritylink/src/constants/image_strings.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/features/core/screens/institutions/inst_model.dart';
import 'package:integritylink/src/features/core/screens/institutions/institution_controller.dart';

class AddInstitutionScreen extends StatefulWidget {
  const AddInstitutionScreen({super.key});

  @override
  State<AddInstitutionScreen> createState() => _AddInstitutionScreenState();
}

class _AddInstitutionScreenState extends State<AddInstitutionScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropdownItems = [
    'Primary',
    'Secondary',
    'University',
    'College'
  ]; // List of dropdown items

  String selectedValue = '';
  final controller = Get.put(InstitutionController());

  @override
  void initState() {
    super.initState();
    selectedValue = dropdownItems[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FormHeaderWidget(
                    image: tWelcomeScreenImage,
                    title: "Add Institution",
                    subTitle: "Enter institution details below",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: tFormHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First Name
                        TextFormField(
                          controller: controller.name,
                          decoration: const InputDecoration(
                            labelText: "School Name",
                            hintText: "Enter School Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please School Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: tFormHeight - 20,
                        ),
                        //last name
                        TextFormField(
                          controller: controller.address,
                          decoration: const InputDecoration(
                            labelText: "Address",
                            hintText: "Enter School Address",
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter School Address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: tFormHeight - 20,
                        ),
                        //Email
                        TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                            labelText: "School Email",
                            hintText: "Enter School Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please Enter School Email';
                            } else if (!GetUtils.isEmail(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: tFormHeight - 20,
                        ),
                        //phone
                        TextFormField(
                          controller: controller.phoneNo,
                          decoration: const InputDecoration(
                            labelText: "School Phone Number",
                            hintText: "Enter School Phone Number",
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter school phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: tFormHeight - 20,
                        ),

                        // Dropdown button
                        DropdownButtonFormField<String>(
                          value: selectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue.toString();
                              print(selectedValue);
                            });
                          },
                          items: dropdownItems.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),

                        SizedBox(
                          height: tFormHeight - 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Add Institution"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final time = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();

                                final school = InstModel(
                                    name: controller.name.text.trim(),
                                    email: controller.email.text.trim(),
                                    phoneNo: controller.phoneNo.text.trim(),
                                    level: selectedValue,
                                    groups: [],
                                    image: "",
                                    createdAt: time,
                                    about: controller.name.text.trim() +
                                        ' on Integrity Link.',
                                    address: controller.address.text.trim(),
                                    pushToken: '');

                                InstitutionController.instance
                                    .createSchool(school);

                                controller.name.clear();
                                controller.email.clear();
                                controller.phoneNo.clear();
                                controller.address.clear();
                              }
                            },
                          ),
                        ),
                      ],
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
}
