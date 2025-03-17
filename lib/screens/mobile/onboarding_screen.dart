import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/theme_switch_button.dart';
import 'package:apidash/screens/mobile/widgets/onboarding_slide.dart';
import 'package:apidash/screens/screens.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  void _onNextPressed() {
    if (currentPageIndex < 2) {
      _carouselController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MobileDashboard(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          const ThemeSwitchButton(),
          TextButton(
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileDashboard(),
                ),
                (route) => false,
              );
              await setOnboardingStatusToSharedPrefs(
                isOnboardingComplete: true,
              );
            },
            child: const Text(
              'Skip',
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.75,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                ),
                items: [
                  OnboardingSlide(
                    context: context,
                    assetPath: kAssetApiServerLottie,
                    assetSize: context.width * 0.75,
                    title: "Test APIs with Ease",
                    description:
                        "Send requests, preview responses, and test APIs with ease. REST and GraphQL support included!",
                  ),
                  OnboardingSlide(
                    context: context,
                    assetPath: kAssetFolderLottie,
                    assetSize: context.width * 0.55,
                    title: "Organize & Save Requests",
                    description:
                        "Save and organize API requests into collections for quick access and better workflow.",
                  ),
                  OnboardingSlide(
                    context: context,
                    assetPath: kAssetGenerateCodeLottie,
                    assetSize: context.width * 0.65,
                    title: "Generate Code Instantly",
                    description:
                        "Integrate APIs using well tested code generators for JavaScript, Python, Dart, Kotlin & others.",
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      bool isSelected = currentPageIndex == index;
                      return GestureDetector(
                        onTap: () {
                          _carouselController.animateToPage(index);
                        },
                        child: AnimatedContainer(
                          width: isSelected ? 40 : 18,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    onPressed: () async {
                      _onNextPressed();
                      await setOnboardingStatusToSharedPrefs(
                        isOnboardingComplete: true,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 30,
                    ),
                    style: IconButton.styleFrom(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
