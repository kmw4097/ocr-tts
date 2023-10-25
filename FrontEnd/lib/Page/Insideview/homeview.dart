// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GetPart/UIPart.dart';
import '../Widgets/home.dart';

final uiset = Get.put(UIPart());

///UI
///
///MainPage의 UI
UI_home(
  context,
  maxWidth,
  maxHeight,
  orientation,
  scrollController,
  searchNode,
  pdfViewerController,
) {
  return GetBuilder<UIPart>(
    builder: (_) {
      return SizedBox(
          height: maxHeight,
          width: maxWidth,
          child: maxWidth <= 1000
              ? PageUI0(context, maxHeight, maxWidth, scrollController,
                  searchNode, pdfViewerController)
              : PageUI1(context, maxHeight, maxWidth, scrollController,
                  searchNode, pdfViewerController));
    },
  );
}

// 세로모드는 PageUI0으로 모든 뷰를 통합.
PageUI0(
  context,
  maxHeight,
  maxWidth,
  scrollController,
  searchNode,
  pdfViewerController,
) {
  return GetBuilder<UIPart>(
    builder: (_) {
      return Container(
        height: maxHeight,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: home(
          context,
          maxHeight,
          maxWidth,
          scrollController,
          pdfViewerController,
          searchNode,
          0,
        ),
      );
    },
  );
}

// 가로모드는 PageUI1으로 모든 뷰를 통합.
PageUI1(
  context,
  maxHeight,
  maxWidth,
  scrollController,
  searchNode,
  pdfViewerController,
) {
  return GetBuilder<UIPart>(
    builder: (_) {
      return Container(
        height: maxHeight,
        padding: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        child: home(
          context,
          maxHeight,
          maxWidth,
          scrollController,
          pdfViewerController,
          searchNode,
          1,
        ),
      );
    },
  );
}
