// ignore_for_file: file_names

import 'package:get/get.dart';
import '../GetPart/UIPart.dart';
import 'Variables.dart';

final uiset = Get.put(UIPart());

double bigTitleTextsize() {
  double ts = 0;
  ts = hugetextsize[uiset.selecttxtscaler];
  return ts;
}

double contentTitleTextsize() {
  double ts = 0;
  ts = hugetextsize[uiset.selecttxtscaler];
  return ts;
}

double contentTextsize() {
  double ts = 0;
  ts = largetextsize[uiset.selecttxtscaler];
  return ts;
}

double contentsmallTextsize() {
  double ts = 0;
  ts = smalltextsize[uiset.selecttxtscaler];
  return ts;
}

double largeiconsize() {
  double ts = 0;
  ts = largeiconsizer[uiset.selecttxtscaler];
  return ts;
}

double iconsize() {
  double ts = 0;
  ts = iconsizer[uiset.selecttxtscaler];
  return ts;
}
