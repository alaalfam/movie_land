import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_land/core/utils/movie_land_colors.dart';
import 'package:movie_land/core/utils/movie_land_dimentions.dart';

class GerdooSnackbar {
  static void showSuccess({required String message}) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MovieLandColors.greenColor,
      borderRadius: 16,
      margin: EdgeInsets.symmetric(
        horizontal: MovieLandDimentions.marginDefault,
        vertical: 96,
      ),
    );
  }

  static void showWarning({required String message}) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MovieLandColors.tertiary70,
      borderRadius: 16,
      margin: EdgeInsets.symmetric(
        horizontal: MovieLandDimentions.marginDefault,
        vertical: 96,
      ),
    );
  }

  static void showError({required String message}) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MovieLandColors.redColor,
      borderRadius: 16,
      margin: EdgeInsets.symmetric(
        horizontal: MovieLandDimentions.marginDefault,
        vertical: 96,
      ),
    );
  }
}
