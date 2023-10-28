// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:open_file/open_file.dart';
import '../../GetPart/UIPart.dart';

loadfile1() async {
  final uiset = Get.put(UIPart());
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'xls', 'xlsx', 'ppt', 'pptx', 'doc', 'docx'],
  );

  if (result != null) {
    uiset.setfilelen(result.files.length);
    if (uiset.filelen > 1) {
      return null;
    } else {
      return result.files.first.path!;
    }
  } else {
    return null;
  }
}

loadfile2() async {
  final uiset = Get.put(UIPart());
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'xls', 'xlsx', 'ppt', 'pptx', 'doc', 'docx'],
  );

  if (result != null) {
    uiset.setfilelen(result.files.length);
    if (uiset.filelen > 1) {
      return null;
    } else {
      Uint8List fileBytes = result.files.first.bytes!;
      return fileBytes;
    }
  } else {
    return null;
  }
}

loadfile3() async {
  final uiset = Get.put(UIPart());
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'xls', 'xlsx', 'ppt', 'pptx', 'doc', 'docx'],
  );

  if (result != null) {
    uiset.setfilelen(result.files.length);
    if (uiset.filelen > 1) {
      return null;
    } else {
      return result.files.first.path!;
    }
  } else {
    return null;
  }
}
