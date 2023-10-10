import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/institutional_group_chat/service/database_service.dart';

class InstitutionController extends GetxController {
  static InstitutionController get instance => Get.find();

  Future<QuerySnapshot> getGroups() {
    return DatabaseService().listOfGrps();
  }
}
