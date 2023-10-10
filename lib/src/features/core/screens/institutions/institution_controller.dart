import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/service/database_service.dart';
import 'package:integritylink/src/features/core/screens/institutions/Institutions_list_home.dart';
import 'package:integritylink/src/features/core/screens/institutions/inst_model.dart';

class InstitutionController extends GetxController {
  static InstitutionController get instance => Get.find();

  final email = TextEditingController();
  final level = TextEditingController();
  final name = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();

  Future<List<InstModel>> getSchools() async {
    return DatabaseService().listOfSchools();
  }

  void createSchool(InstModel school) async {
    await DatabaseService().createSchool(school).then(
          (value) => Get.to(
            () => InstitutionHome(),
          ),
        );
  }

  Future<QuerySnapshot> getGroups() {
    return DatabaseService().listOfGrps();
  }
}
