import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/constants/text_strings.dart';

import '../../../controllers/otp_controller.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controller = Get.put(OTPController());

    var otp;

    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tOtpTitle,
                style: GoogleFonts.montserrat(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tOtpSubTitle.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 40.0,
              ),
              Text(
                "$tOtpMessage email",
                textAlign: TextAlign.center,
              ),
              OtpTextField(
                numberOfFields: 6,
                filled: true,
                fillColor: Colors.black.withOpacity(0.1),
                borderColor: Colors.black,
                showFieldAsBox: true,
                borderWidth: 2.0,
                onSubmit: (code) {
                  otp = code;
                  print("OTP: $otp");

                  OTPController.instance.verifyOTP(otp);
                }, // end onSubmit
              ),
              const SizedBox(
                height: 40.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    OTPController.instance.verifyOTP(otp);
                  },
                  child: Text(tNext.toUpperCase()),
                ),
              ),
            ],
          )),
    );
  }
}
