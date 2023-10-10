import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    onBoardingPageWidget(
      model: onBoardingModel(
        image: tOnboardingImage1,
        title: tOnboardingTitle1,
        subTitle: tOnboardingSubTitle1,
        counterText: tOnboardingCounter1,
        bgColor: tOnboardingPage1Color,
      ),
    ),
    onBoardingPageWidget(
      model: onBoardingModel(
        image: tOnboardingImage2,
        title: tOnboardingTitle2,
        subTitle: tOnboardingSubTitle2,
        counterText: tOnboardingCounter2,
        bgColor: tOnboardingPage2Color,
      ),
    ),
    onBoardingPageWidget(
      model: onBoardingModel(
        image: tOnboardingImage3,
        title: tOnboardingTitle3,
        subTitle: tOnboardingSubTitle3,
        counterText: tOnboardingCounter3,
        bgColor: tOnboardingPage3Color,
      ),
    )
  ];

  onPageChangeCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}
