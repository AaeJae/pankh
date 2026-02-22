import 'package:flutter/material.dart';
import 'package:pankh/widgets/wid_uihelper.dart';

import '../constants/designtokens.dart';
import '../services/ser_user.dart';
import '../services/ser_auth.dart';

class WidDialog {
  static Future<String?> customDialog(
      BuildContext context,
      String textTitle,
      Widget body,
      List<DialogPill> pills,
      {
        bool canClose = false, // Changed default to false
      }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: canClose, // Prevent accidental closing
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.colPrimary.withValues(alpha:0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: UiHelper.customText(
            text: textTitle,
            color: AppColors.colWhite,
            fontSize: AppFontSizes.fontSizeTitle,
            fontFamily: AppTypography.fontTitle,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Directly render the widget passed in
            body,
            const SizedBox(height: 24),

            // Generate pills dynamically
            for (var pill in pills)
              customDialogPill(context, pill.label, pill.action),
          ],
        ),
      ),
    );
  }
  ///////////////////
  // DIALOG BUILDER
  //////////////////
  static Widget customDialogPill(BuildContext context, String label, String targetPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => Navigator.pop(context, targetPage),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
              child: UiHelper.customText(text: label, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppTypography.fontSubtitle)
          ),
        ),
      ),
    );
  }

  ///////////////////
  // AUTH
  ///////////////////
  static Future<void> showAuthSuccessDialog(BuildContext context, String name) {
    return customDialog(
      context,
      "Welcome to Pankh!",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UiHelper.customText(
            text: "Auth Successful! 🌿",
            color: AppColors.colOnPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          UiHelper.customText(
            text: "Happy Birding, $name. Your XP and progress are now synced to your account.",
            textAlign: TextAlign.center,
            fontSize: AppFontSizes.fontSizeCaption,
            color: AppColors.colOnPrimary,
          ),
        ],
      ),
      [
        DialogPill(label: "Let's Go!", action: "done"),
      ],
    );
  }

  static Future<void> showLoadingDialog(BuildContext context) {
    return customDialog(
      context,
      "Authenticating...", // Title
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.colOnPrimary),
        ),
      ),
      [], // No pills/buttons, prevents user from skipping
      canClose: false, // Prevents closing by tapping outside
    );
  }

  static Future<void> showLoginDialog(BuildContext context) async {
    final String? action = await customDialog(
      context,
      "Login/ Signup",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 50, color: AppColors.colPrimary),
          const SizedBox(height: 15),
        ],
      ),
      [
        DialogPill(label: "Login with Google", action: "login_google"),
      ],
      canClose: true,
    );

    if (action == "login_google") {
      showLoadingDialog(context);
      final loggedInUser = await SerAuth().signInWithGoogle(pendingXP: SerUser.currentXP);
      if (context.mounted) Navigator.pop(context); // Remove loading

      if (loggedInUser != null && context.mounted) {
        SerUser.startListening();
        showAuthSuccessDialog(context, loggedInUser.displayName ?? "Birder");
      }
    }
  }
  ///////////////////
  // end AUTH
  ///////////////////
}

class DialogPill {
  final String label;
  final String action;

  DialogPill({required this.label, required this.action});
}