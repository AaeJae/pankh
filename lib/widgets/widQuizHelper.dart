import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'wid_uihelper.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class WidQuizHelper {
  /// 1. Unified Glassmorphic Chip
  static Widget infoChip(String text, {Color? color}) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sizeSmall,
            vertical: AppSizes.sizeXXSmall
        ),
        decoration: BoxDecoration(
          color: color ?? AppColors.colSecondary.withAlpha(AppAlpha.alphaXLow),
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge),
        ),
        child: Text(text, style: AppTypography.bodyBold,)
    );
  }

  /// PROGRESS BAR
  static Widget progressBar(int current, int total) {
    double progressValue = total == 0 ? 0 : (current + 1) / total;
    return AppProgress(
      value: progressValue.clamp(0.0, 1.0),
      thickness: AppSizes.sizeXXSmall,
    );
  }

  /// 3. Media Wrapper (The Stage)
  static Widget buildMediaWrapper({
    required Widget mediaWidget,
    required bool isQuizStarted
  }) {
    return Center(
      child: AnimatedContainer(
        duration: AppDurations.durationMedium,
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: AppColors.colPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge),
          border: Border.all(color: AppColors.colWhite.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.sizeLarge),
          child: isQuizStarted ? mediaWidget : const SizedBox.shrink(),
        ),
      ),
    );
  }

  //////////////////////////////////
  // AUDIO PLAYER + WAVEFORM
  /////////////////////////////////

  static Widget buildAudioUI({
    required PlayerController controller,
    required VoidCallback onReplay,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.sizeLarge),
        UiHelper.customText(
            text: "Listen to the bird's audio",
            color: AppColors.colWhite,
            fontSize: AppFontSizes.fontSizeSubtitle,
            fontFamily: AppTypography.fontSubtitle
        ),
        const SizedBox(height: AppSizes.sizeMedium),
        birdAudioVisualizer(controller: controller, waveColor: AppColors.colWhite),
        const SizedBox(height: AppSizes.sizeSmall),
      ],
    );
  }

  static Widget birdAudioVisualizer({
    required PlayerController controller,
    required Color waveColor
  }) {
    return AudioFileWaveforms(
      size: const Size(300, 100),
      playerController: controller,
      enableSeekGesture: true,
      waveformType: WaveformType.fitWidth,
      playerWaveStyle: PlayerWaveStyle(
        fixedWaveColor: waveColor.withValues(alpha: 0.2),
        liveWaveColor: waveColor,
        spacing: 3,
        waveThickness: 2,
        scaleFactor: 300,
        showSeekLine: true,
      ),
    );
  }

  //////////////////////////////////
  // TIME AND COUNTER
  /////////////////////////////////
  static Widget buildBigCounter(int countdown) {
    return Center(
      child: Text(
          "$countdown",
          style: AppTypography.title1.copyWith(
              fontSize: 80,
              color: AppColors.colWhite
          )
      ),
    );
  }

  static String formatTime(Duration d) {
    if (d.isNegative) return "00:00";
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

}