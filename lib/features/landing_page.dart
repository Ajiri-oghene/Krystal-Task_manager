// FILE: lib/features/landing_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/features/home/home._screen.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/navigation.dart';

/// First screen shown to new users – introduces the app and navigates to HomeScreen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  /// Builds the full onboarding layout with illustration, text, and start button
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? size.width * 0.15 : 24.0;
    final verticalPadding = 20.0;

    /// Scales font size for tablet vs phone
    double fontScale(double s) => isTablet ? s * 1.2 : s;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          /// Determines if content needs scrolling based on available height
          builder: (context, constraints) {
            final allowScroll = constraints.maxHeight < 600;
            final content = Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Illustration image (girl with laptop)
                  Image.asset(
                    'assets/images/girl.png',
                    width: isTablet ? size.width * 0.5 : size.width * 0.7,
                    height: isTablet ? size.height * 0.35 : size.height * 0.3,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(flex: 1),

                  // Main title
                  Text(
                    'Task Management &\nTo-Do List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: fontScale(22),
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle description
                  Text(
                    'This productive tool is designed to help you better manage your task project-wise conveniently!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: fontScale(15),
                      color: AppColor.black,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(flex: 2),

                  // "Let's Start" button with arrow icon
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigation.gotoWidget(context, HomeScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Let's Start",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: fontScale(26),
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(
                                'assets/svg/Arrow - Left.svg',
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ],
                        )),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            );

            // Enable scrolling only on small screens
            return allowScroll
                ? SingleChildScrollView(child: content)
                : content;
          },
        ),
      ),
    );
  }
}
