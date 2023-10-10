import 'package:flutter/material.dart';
import 'package:integritylink/src/common_widgets/form/form_header_widget.dart';
import 'package:integritylink/src/constants/sizes.dart';
import 'package:integritylink/src/features/authentication/screens/signup/widgets/signup_footer_widget.dart';
import 'package:integritylink/src/features/authentication/screens/signup/widgets/signup_form_widget.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                ),
                SignUpFormWidget(),
                signup_footer_widget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
