import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/cases/case_repo.dart';
import 'package:integritylink/src/features/core/screens/cases/cases_list.dart';
import 'package:integritylink/src/features/core/screens/cases/model_case.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();

  final _caseRepo = Get.put(CaseRespository());
  //get user email and pass to userRepository to fetch user details

//get all cases
  Future<List<CaseModel>> getAllCases() async {
    return _caseRepo.getAllCases();
  }

  //save case

  Future<void> saveCase(
      CaseModel caseModel, String generateRandomString) async {
    //snackbar
    Get.snackbar(
      "Please wait",
      "Saving case",
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(
        Icons.sync_rounded,
        color: Colors.green,
      ),
    );
    await _caseRepo.saveCase(caseModel.toJson()).whenComplete(() {
      print("Case saved successfully : Case ID = $generateRandomString");

      Get.snackbar(
        "Success",
        "Case saved successfully : Case ID = $generateRandomString",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 10),
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
      );
      Get.to(() => CaseListScreen());
    }).catchError((onError) {
      Get.snackbar(
        "Error",
        "Case not saved",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return onError;
    });
    ;
  }

  // updateRecord(UserModel user) async {
  //   Get.snackbar(
  //     "Please wait",
  //     "Updating user details",
  //     snackPosition: SnackPosition.BOTTOM,
  //     icon: Icon(
  //       Icons.sync_rounded,
  //       color: Colors.green,
  //     ),
  //   );
  //   await _caseRepo.updateUserRecord(user);
  // }
}
