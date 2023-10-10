import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/group_chat/service/database_service.dart';

class CommunityController extends GetxController {
  static CommunityController get instance => Get.find();

  Future<QuerySnapshot> getGroups() {
    return DatabaseService().listOfGrps();
  }
}
