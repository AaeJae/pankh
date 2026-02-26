import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/services/ser_auth.dart';
import 'package:pankh/services/ser_user.dart';

import '../screens/explorescreen/explorescreen.dart';
import '../screens/quizscreen/quizscreen.dart';

class WidDialog {
  /// The "Bridge" function that mimics the original behavior
  /// while routing everything through the new AppDialog component.
  static Future<T?> customDialog<T>(
      BuildContext context,
      String textTitle,
      Widget body,
      List<AppButton> buttons, {
        bool canClose = true,
      }) {
    return AppDialog.show<T>(
      context,
      title: textTitle,
      subtitle: body,
      isClosable: canClose,
      items: buttons,
    );
  }

  ///////////////////////////////////
  // QUIZ DIALOGS
  ///////////////////////////////////
  static Future<void> showDifficultyPicker(BuildContext context) async {
    double _tempSliderValue = 0; // Local state for the slider index

    await AppDialog.show(
      context,
      title: "Select Difficulty",
      isClosable: true,
      subtitle: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose a level that matches your birding expertise.",
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSizes.sizeMedium),
              AppSlider(
                value: _tempSliderValue,
                min: 0,
                max: (QuizLevel.values.length - 1).toDouble(),
                // Map the Enum to display strings for the slider
                customLabels: QuizLevel.values.map((e) => e.displayText).toList(),
                onChanged: (newValue) {
                  setDialogState(() {
                    _tempSliderValue = newValue;
                  });
                },
              ),
            ],
          );
        },
      ),
      items: [
        AppButton(
          label: "Start Quiz",
          variant: AppButtonVariant.solid,
          onPressed: () {
            // 1. Get the Enum based on slider index
            final QuizLevel selectedLevel = QuizLevel.values[_tempSliderValue.round()];
            debugPrint("selcted Level: ${selectedLevel.databaseValue}");
            // 2. Close the dialog first
            Navigator.pop(context);

            // 3. Push to QuizScreen passing the Enum object
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  difficulty: selectedLevel.databaseValue, // Pass the QuizLevel enum here
                  onQuit: () => Navigator.pop(context),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
  static Future<String?> showResults(
      BuildContext context,
      int correct,
      int total,
      bool isGuest,
      ) {
    return AppDialog.show<String>(
      context,
      title: "Quiz Finished! ✨",
      isClosable: true,
      subtitle: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🎊  Final Score: $correct / $total  🎊", style: AppTypography.bodyBold),
            const SizedBox(height: AppSizes.sizeSmall),
            Text("Keep going!", style: AppTypography.body),
            const SizedBox(height: AppSizes.sizeSmall),
            if(isGuest)
              Text("+100 XP awarded", style: AppTypography.body),
            if(isGuest)
              Text("To claim, you must login asap!", style: AppTypography.body),
            const SizedBox(height: AppSizes.sizeSmall),
          ],
        ),
      ),
      items: [
        if (isGuest)
          AppButton(
            label: "Login with Google",
            icon: Icons.login,
            variant: AppButtonVariant.solid,
            size: AppButtonSize.medium,
            onPressed: () => Navigator.pop(context, "login"),
          ),
        AppButton(
          label: "Play Again",
          variant: isGuest ? AppButtonVariant.flat : AppButtonVariant.solid,
          size: AppButtonSize.medium,
          onPressed: () => Navigator.pop(context, "restart"),
        ),
        AppButton(
          label: "Explore More Birding!",
          variant: isGuest ? AppButtonVariant.flat : AppButtonVariant.solid,
          size: AppButtonSize.medium,
          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const ExploreScreen(),)),
        ),
      ],
    );
  }
  static Future<void> showExitConfirmation(BuildContext context,) async {
    // Use AppDialog.show with a generic type <String> to capture the button result
    final String? result = await AppDialog.show<String>(
      context,
      title: "Quit Quiz?",
      isClosable: true,
      subtitle: Text(
        "Your current progress will be lost!",
        style: AppTypography.body, // Using AppTypography from your system
      ),
      items: [
        // Ghost variant for the "safe" action to keep focus on the primary task
        AppButton(
          label: "Stay",
          variant: AppButtonVariant.solid,
          onPressed: () => Navigator.pop(context, "stay"),
        ),
        // Solid variant for the destructive action to ensure high visibility
        AppButton(
          label: "Quit",
          variant: AppButtonVariant.flat,
          onPressed: () => Navigator.pop(context, "quit"),
        ),
      ],
    );
    if (result == "quit") {
      Navigator.push(context,MaterialPageRoute(builder: (context) => const ExploreScreen(),));    }
  }
  ///////////////////////////////////
  // AUTH DIALOGS
  ///////////////////////////////////

  static Future<void> showDialogLogin(BuildContext context) async {
    final String? action = await AppDialog.show<String>(
      context,
      title: "Login / Signup",
      isClosable: true,
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 50,
            color: AppColors.colPrimary,
          ),
          const SizedBox(height: AppSizes.sizeSmall),
          const Text(
            "Sync your progress and compete with the community!",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      items: [
        AppButton(
          label: "Login with Google",
          icon: Icons.login,
          onPressed: () => Navigator.pop(context, "login_google"),
        ),
      ],
    );

    if (action == "login_google") {
      showDialogLoading(context);
      final loggedInUser = await SerAuth().signInWithGoogle(pendingXP: SerUser.currentXP);

      if (context.mounted) Navigator.pop(context); // Close loading dialog

      if (loggedInUser != null && context.mounted) {
        SerUser.startListening();
        showDialogAuthSuccess(context, loggedInUser.displayName ?? "Birder");
      }
    }
  }

  static void showDialogLoading(BuildContext context) {
    AppDialog.show(
      context,
      title: "Authenticating...",
      isClosable: false,
      subtitle: const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.sizeMedium),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.colPrimary),
        ),
      ),
      items: [], // No buttons for non-closable loading state
    );
  }

  static void showDialogAuthSuccess(BuildContext context, String name) {
    AppDialog.show(
      context,
      title: "Welcome to Pankh!",
      isClosable: true,
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Auth Successful! 🌿",
            style: AppTypography.subtitle1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.sizeXSmall),
          Text(
            "Happy Birding, $name. Your XP and progress are now synced.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      items: [
        AppButton(
          label: "Let's Go!",
          variant: AppButtonVariant.solid, // Explicitly using design system variants
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}