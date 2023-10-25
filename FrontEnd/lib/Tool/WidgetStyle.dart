// ignore_for_file: unused_local_variable, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../GetPart/UIPart.dart';
import 'TextSize.dart';

responsivewidget(widget, width) {
  return SizedBox(
    width: width > 1000 ? width * 0.8 : width,
    child: widget,
  );
}

Responsivelayout(landscape, portrait, orientation) {
  if (orientation == Orientation.landscape) {
    return landscape;
  } else {
    return portrait;
  }
}

class ContainerDesign extends StatelessWidget {
  const ContainerDesign(
      {Key? key, required this.child, required this.color, required this.type})
      : super(key: key);
  final Widget child;
  final Color color;
  final int type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UIPart>(
        builder: (_) => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: type == 1 ? uiset.backgroundcolor : color,
                  border: type == 1
                      ? Border.all(color: color, width: 2)
                      : const Border()),
              child: child,
            ));
  }
}

/*
  NoBehavior는 스크롤 뷰에서 상하부 모션을 삭제하는 클래스
 */
class NoBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
