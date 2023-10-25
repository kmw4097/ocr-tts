// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'MyTheme.dart';
import 'TextSize.dart';

OSDialog(context, title, content) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: title,
    content: content,
  );
}

OSDialogwithtwobtn(context, title, content) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: title,
    content: content,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Get.back(result: true);
        },
        child: Text('모바일',
            style: TextStyle(
                color: MyTheme.colororigblue,
                fontWeight: FontWeight.bold,
                fontSize: contentsmallTextsize())),
      ),
      TextButton(
        onPressed: () {
          Get.back(result: false);
        },
        child: Text('웹',
            style: TextStyle(
                color: MyTheme.colorgrey,
                fontWeight: FontWeight.bold,
                fontSize: contentsmallTextsize())),
      ),
    ],
  );
}

void pressed1() {
  SystemNavigator.pop();
}
