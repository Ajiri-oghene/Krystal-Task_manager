// FILE: lib/utils/navigation.dart
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Utility class for handling app navigation with customizable animations and stack behavior
class Navigation {
  /// Navigates to a new screen with optional animation and stack control
  static Future<void> gotoWidget(
    BuildContext? context,
    Widget screen, {
    bool replacePreviousScreen = false,
    bool clearStack = false,
    bool rootNavigator = false,
    bool fullScreenDialog = false,
    PageTransitionType animationType = PageTransitionType.fade,
  }) async {
    // Push new screen normally
    if (!clearStack) {
      if (!replacePreviousScreen) {
        await Navigator.of(context!, rootNavigator: rootNavigator).push(
          PageTransition(
            type: animationType,
            child: screen,
          ),
        );
      }
      // Replace current screen with new one
      else {
        await Navigator.of(context!, rootNavigator: rootNavigator)
            .pushReplacement(
          PageTransition(
            type: animationType,
            child: screen,
          ),
        );
      }
    }
    // Clear entire stack and show new screen as root
    else {
      await Navigator.of(context!, rootNavigator: rootNavigator)
          .pushAndRemoveUntil(
        PageTransition(
          type: animationType,
          child: screen,
        ),
        (_) => false,
      );
    }
  }

  /// Navigates to a named route with optional arguments and stack clearing
  static Future<void> gotoNamed(
    BuildContext context,
    String route, {
    bool clearStack = false,
    bool rootNavigator = false,
    dynamic args = Object,
  }) async {
    // Navigate to named route normally
    if (!clearStack) {
      await Navigator.of(context, rootNavigator: rootNavigator).pushNamed(
        route,
        arguments: args,
      );
    }
    // Clear stack and navigate to named route as new root
    else {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        route,
        (_) => false,
        arguments: args,
      );
    }
  }

  /// Pops the current screen and returns to previous one
  static void goBack(
    BuildContext context, {
    bool rootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: rootNavigator).pop();
  }
}
