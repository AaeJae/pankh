import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/models/mod_bird.dart';
import 'package:pankh/widgets/widDialog.dart';

import '../screens/quizscreen/quiz_binocs.dart';
import '../screens/quizscreen/quiz_birdle.dart';
import '../screens/quizscreen/quiz_puzzle.dart';
import '../screens/quizscreen/quiz_size.dart';
import '../screens/quizscreen/quizscreen.dart';

class WidQuizHelper {
  //Quiz Router
  static void navigateToQuiz(
      BuildContext context,
      String difficulty,
      String quizTitle,
      int quizTotalQuestions,
      int quizDurationMins,
      Map<String, dynamic>? quizFilters,
      ) {
    final String quizType = quizFilters?['quizType'] ?? 'sound';
    Widget destination;

    List<String> difficultyList = difficulty.split(',').map((e) => e.trim()).toList();
    Map<String, dynamic>? birdFilters = {'rank': difficultyList};

    debugPrint("inside navigateToQuiz() quizType: ${quizType}");
    switch (quizType) {
      case 'birdle':
        birdFilters.addAll({
          'hasDiet': true,
          'hasHabitat': true,
          'hasFamily': true,
          'hasiucnStatus': true,
          'hasImage': true
        });
        debugPrint("inside birdle switch quizType: ${quizType}");
        destination = QuizBirdleScreen(
          quizTitle: quizTitle,
          quizTotalQuestions: quizTotalQuestions,
          quizDurationMins: quizDurationMins,
          quizFilters: quizFilters,
          birdFilters: birdFilters,
          onQuit: () => Navigator.pop(context),
        );
        break;

      case 'binocs':
        birdFilters.addAll({

          "hasImage": true
        });
        destination = BinocsScreen(
          quizTitle: quizTitle,
          quizDurationMins: quizDurationMins,
          quizFilters: quizFilters,
          birdFilters: birdFilters,
          onQuit: () => Navigator.pop(context),
        );
        break;

      case 'puzzle':
        birdFilters.addAll({
          'hasImage': true,
        });
        destination = QuizPuzzleScreen(
          quizTitle: quizTitle,
          quizTotalQuestions: quizTotalQuestions,
          quizDurationMins: quizDurationMins,
          quizFilters: quizFilters,
          birdFilters: birdFilters,
          onQuit: () => Navigator.pop(context),
        );
        break;
      case 'size':
        birdFilters.addAll({
          "hasImage": true
        });
        destination = QuizSizeScreen(
          // quizTitle: quizTitle,
          // quizTotalQuestions: quizTotalQuestions,
          // quizDurationMins: quizDurationMins,
          // quizFilters: quizFilters,
          // onQuit: () => Navigator.pop(context),
        );
        break;
      default: // sound, image, meme, fashion
        debugPrint("inside default switch: quizType: ${quizType},difficulty: ${difficulty}, quizTitle: ${quizTitle}, quizTotalQuestions: ${quizTotalQuestions}, quizDurationMins: ${quizDurationMins}, quizFilters: ${quizFilters} ");
        birdFilters.addAll({
          "hasImage": true,
          "hasAudio": true,
          "hasLore": true
        });
        destination = QuizScreen(
          quizTitle: quizTitle,
          quizTotalQuestions: quizTotalQuestions,
          quizDurationMins: quizDurationMins,
          quizFilters: quizFilters,
          birdFilters: birdFilters,
          onQuit: () => Navigator.pop(context),
        );
    }
    debugPrint("about to push");
    Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
  }
  // end QuizRouter

  static Widget buildTopHeader(BuildContext context, String title){
    debugPrint("inside buildTopHeaderquizTitle: ${title}");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: AppSizes.sizeLarge),
        Text(title,style: AppTypography.subtitle1.copyWith(color: AppColors.colPrimary, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.colPrimary, size: 28),
          onPressed: () => WidDialog.showExitConfirmation(context),
        ),
      ],
    );
  }
  static Widget buildProgressBar(int currentIndex, int birdLength, timerNotifier){
    debugPrint("currentIndex: ${currentIndex}, birdLength: ${birdLength}, timerNotifier: ${timerNotifier}");
    return Row(
      children: [
        WidQuizHelper.infoChip("${currentIndex + 1}  /  ${birdLength}",),
        const SizedBox(width: AppSizes.sizeSmall),

        Expanded(child: WidQuizHelper.progressBar(currentIndex+1,birdLength,),),
        const SizedBox(width: AppSizes.sizeSmall),

        ValueListenableBuilder<Duration>(
          valueListenable: timerNotifier,
          builder: (context, time, _) => WidQuizHelper.infoChip(WidQuizHelper.formatTime(time)),
        ),
      ],
    );
  }
  static Widget infoChip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.sizeSmall, vertical: AppSizes.sizeXXSmall),
    decoration: BoxDecoration(color: AppColors.colSecondary.withAlpha(AppAlpha.alphaMedium), borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: AppTypography.bodyBold.copyWith(color: Colors.white)),
  );

  static Widget progressBar(int current, int total) => AppProgress(value: total == 0 ? 0 : current / total, thickness: 8);

  static String formatTime(Duration d) => "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  static Widget buildMediaContent({
    required ModBird bird,
    required String currentQuizType,
    required PlayerController controller,
    required VoidCallback onReplay,
  }) {
    if (currentQuizType == "sound") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Playing bird sound 🎶", style: AppTypography.subtitle2.copyWith(color: AppColors.colOnPrimary)),
          // IconButton(
          //   onPressed: onReplay,
          //   icon: Icon(Icons.music_note,
          //   color: Colors.white,
          //   size: 40)
          // ),
          AudioFileWaveforms(
            padding: EdgeInsets.all(AppSizes.sizeSmall),
            size: const Size(double.infinity, 50),
            playerController: controller,
            enableSeekGesture: true,
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: PlayerWaveStyle(
              fixedWaveColor: AppColors.colPrimary,
              liveWaveColor: AppColors.colTertiary,
              spacing: 5, // customize
              waveThickness: 2, // customize
              scaleFactor: 500, // customize
              showSeekLine: true,
            ),
          ),
          const SizedBox(height: AppSizes.sizeXLarge),
        ],
      );
    } else { // TODO handle other types than sound
      return Image.network(bird.featuredImage.imageURL, fit: BoxFit.cover, height: double.infinity, width: double.infinity);
    }
  }


  static Widget buildBigCounter(int countdown) {
    return Align(
      alignment: Alignment.center,
      child: Text("$countdown",style: AppTypography.title1.copyWith(fontSize: 80,color: AppColors.colPrimary)),
    );
  }

}