// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'GetPart/UIPart.dart';

initScreen() async {
  final uiset = Get.put(UIPart());
  final box = GetStorage();

  /**
  * loadLocale : app의 언어를 지정해줌.
  */
  uiset.loadLocale();
  /**
  * setappbox : app의 색상을 지정해줌.
  */
  uiset.setappbox();
}
