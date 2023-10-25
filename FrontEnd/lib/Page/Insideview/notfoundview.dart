// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GetPart/UIPart.dart';
import '../../Tool/MyTheme.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(UIPart());

///UI
///
///MainPage의 UI
UI(
  context,
  maxWidth,
  maxHeight,
  orientation,
) {
  return GetBuilder<UIPart>(
    builder: (_) {
      return SizedBox(
        height: maxHeight,
        width: maxWidth,
        child: PageUI0(
          context,
          maxHeight,
          maxWidth,
        ),
      );
    },
  );
}

PageUI0(context, maxHeight, maxWidth) {
  return Container(
    height: 200,
    padding: const EdgeInsets.only(left: 20, right: 20),
    alignment: Alignment.center,
    child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Text(
              '404 Not Found\n So Please click below two page options where you want to go!',
              maxLines: 10,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: contentTextsize(),
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onHover: (value) {},
                  onTap: () async {
                    uiset.setpageindex(0);
                  },
                  child: Center(
                    child: Text('Portfolio', style: MyTheme.btntext),
                  ),
                ),
              ],
            ))
          ],
        )),
  );
}
