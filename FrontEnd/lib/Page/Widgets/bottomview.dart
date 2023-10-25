// ignore_for_file: non_constant_identifier_names

import 'package:dplit/Tool/MyTheme.dart';
import 'package:dplit/Tool/TextSize.dart';
import 'package:dplit/Tool/WidgetStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../GetPart/UIPart.dart';

AddContent(context, title, searchnode) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: Get.width > 1000 ||
                MediaQuery.of(context).orientation == Orientation.landscape
            ? Get.width * 0.5
            : Get.width,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Get.width > 1000 ||
                        MediaQuery.of(context).orientation ==
                            Orientation.landscape
                    ? Get.width * 0.5
                    : Get.width,
              ),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return GestureDetector(
                        onTap: () {
                          searchnode.unfocus();
                        },
                        child: infos(context, title),
                      );
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

infos(context, title) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 30,
                          alignment: Alignment.topCenter,
                          color: MyTheme.colorgrey),
                    ],
                  )),
              title == const SizedBox()
                  ? const SizedBox(
                      height: 0,
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              title,
              const SizedBox(
                height: 20,
              ),
              contentbody(context),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

contentbody(context) {
  return SizedBox(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<UIPart>(builder: (_) {
            return SizedBox(
              child: Row(
                children: [
                  /*Icon(
                    FontAwesome.text_height,
                    size: 25,
                    color: MyTheme.colororigblue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),*/
                  Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        '글자 크기',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: contentsmallTextsize(),
                            color: MyTheme.colorgrey),
                        overflow: TextOverflow.ellipsis,
                      )),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (uiset.selecttxtscaler != 0) {
                            uiset.settextscale(uiset.selecttxtscaler - 1);
                          } else {}
                        },
                        child: Icon(
                          AntDesign.minussquareo,
                          size: iconsize(),
                          color: MyTheme.colororigred,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (uiset.selecttxtscaler != 4) {
                            uiset.settextscale(uiset.selecttxtscaler + 1);
                          } else {}
                        },
                        child: Icon(
                          AntDesign.plussquareo,
                          size: iconsize(),
                          color: MyTheme.colorblack,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          GetBuilder<UIPart>(
            builder: (_) {
              return uiset.selecttxtscaler == 4 || uiset.selecttxtscaler == 0
                  ? Row(
                      children: [
                        Icon(
                          Feather.info,
                          size: 25,
                          color: MyTheme.colororigred,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          uiset.selecttxtscaler == 4
                              ? '조절할 수 있는 최대치입니다.'
                              : (uiset.selecttxtscaler == 0
                                  ? '조절할 수 있는 최저치입니다.'
                                  : ''),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              wordSpacing: 2,
                              letterSpacing: 2,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: MyTheme.colororigred),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  : const SizedBox();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<UIPart>(builder: (_) {
            return SizedBox(
              child: Row(
                children: [
                  /*Icon(
                    MaterialCommunityIcons.text_to_speech,
                    size: iconsize(),
                    color: MyTheme.colororigblue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),*/
                  Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        '음성 지원설정',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: contentsmallTextsize(),
                            color: MyTheme.colorgrey),
                        overflow: TextOverflow.ellipsis,
                      )),
                  InkWell(
                    onTap: () {
                      uiset.setspeechtoggle(!uiset.isspeechtoggle);
                    },
                    child: Icon(
                      uiset.isspeechtoggle
                          ? Feather.toggle_right
                          : Feather.toggle_left,
                      size: iconsize(),
                      color: uiset.isspeechtoggle
                          ? MyTheme.colororigblue
                          : MyTheme.colorblack,
                    ),
                  )
                ],
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<UIPart>(builder: (_) {
            return SizedBox(
              child: Row(
                children: [
                  /*Icon(
                    EvilIcons.redo,
                    size: iconsize(),
                    color: MyTheme.colororigblue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),*/
                  Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        '설정 초기화',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: contentsmallTextsize(),
                            color: MyTheme.colorgrey),
                        overflow: TextOverflow.ellipsis,
                      )),
                  InkWell(
                    onTap: () {
                      uiset.setspeechtoggle(true);
                      uiset.settextscale(2);
                    },
                    child: Icon(
                      Ionicons.checkmark_done_outline,
                      size: iconsize(),
                      color: MyTheme.colororigred,
                    ),
                  )
                ],
              ),
            );
          }),
        ]),
  );
}
