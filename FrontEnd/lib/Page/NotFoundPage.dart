// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types, file_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../GetPart/UIPart.dart';
import '../Tool/WidgetStyle.dart';
import 'Insideview/notfoundview.dart';
import 'Widgets/appbarview.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage>
    with TickerProviderStateMixin {
  final searchNode = FocusNode();
  late TextEditingController textcontroller;
  final uiset = Get.put(UIPart());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    uiset.pagenumber = 99;
    textcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: OrientationBuilder(
      builder: (context, orientation) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: uiset.backgroundcolor,
            statusBarBrightness:
                uiset.statusbarcolor == 0 ? Brightness.dark : Brightness.light,
            statusBarIconBrightness: uiset.statusbarcolor == 0
                ? Brightness.dark
                : Brightness.light));
        return Scaffold(
            backgroundColor: uiset.backgroundcolor,
            body: GetBuilder<UIPart>(builder: (_) => MainBody()));
      },
    ));
  }

  Widget MainBody() {
    return OrientationBuilder(builder: ((context, orientation) {
      return GetBuilder<UIPart>(
          builder: (_) => GestureDetector(
                onTap: () {
                  searchNode.unfocus();
                },
                child: SizedBox(
                  height: Get.height <= 300 ? 250 : Get.height,
                  width: Get.width,
                  child: GetBuilder<UIPart>(
                    builder: (_) {
                      return Container(
                          color: uiset.backgroundcolor,
                          child: Column(
                            children: [
                              AppBarCustom(
                                  title: 'Portio',
                                  node: searchNode,
                                  textcon: textcontroller),
                              Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                  width: Get.width > 1000
                                      ? Get.width - 120
                                      : Get.width,
                                  child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      }, scrollbars: false),
                                      child: LayoutBuilder(
                                        builder: ((context, constraint) {
                                          return Column(
                                            children: [
                                              responsivewidget(
                                                UI(
                                                  context,
                                                  constraint.maxWidth,
                                                  constraint.maxHeight,
                                                  orientation,
                                                ),
                                                Get.width,
                                              ),
                                            ],
                                          );
                                        }),
                                      )),
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
                ),
              ));
    }));
  }
}
