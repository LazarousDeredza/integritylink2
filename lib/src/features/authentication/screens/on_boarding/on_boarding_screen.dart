import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:integritylink/src/features/authentication/controllers/on_boarding-controller.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constants/colors.dart';

class onBoardingScreen extends StatelessWidget {
  onBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final obController = OnBoardingController();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: obController.pages,
            liquidController: obController.controller,
            onPageChangeCallback: obController.onPageChangeCallback,
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: tPrimaryColor,
            ),
            enableSideReveal: true,
          ),
          Positioned(
            top: 30.0,
            right: 2.0,
            child: TextButton(
              onPressed: () => obController.skip(),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30.0,
            child: OutlinedButton(
              onPressed: () => obController.animateToNextSlide(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, side: const BorderSide(
                  color: Colors.black26,
                ),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tDarkColor,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned(
              bottom: 10,
              child: AnimatedSmoothIndicator(
                activeIndex: obController.currentPage.value,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 5.0,
                  dotColor: tPrimaryColor,
                  activeDotColor: tAccentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
