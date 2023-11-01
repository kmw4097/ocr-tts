// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../GetPart/UIPart.dart';
import '../../Tool/MyTheme.dart';
import '../../Tool/TextSize.dart';
import '../../Tool/Variables.dart';
import '../../Tool/WidgetStyle.dart';
import 'bottomview.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    Key? key,
    required this.title,
    required this.node,
    required this.textcon,
  }) : super(key: key);
  final String title;
  final FocusNode node;
  final TextEditingController textcon;

  @override
  Widget build(BuildContext context) {
    final uiset = Get.put(UIPart());

    return StatefulBuilder(builder: ((context, setState) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: uiset.backgroundcolor,
          statusBarBrightness:
              uiset.statusbarcolor == 0 ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              uiset.statusbarcolor == 0 ? Brightness.dark : Brightness.light));
      return GetBuilder<UIPart>(
          builder: (_) => SafeArea(
              child: responsivewidget(
                  SizedBox(
                    height: Get.height > 300 ? 50 : 0,
                    child: Column(
                      children: [
                        SizedBox(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onHover: (value) {},
                                    onTap: () {
                                      uiset.setpageindex(0);
                                    },
                                    child: SizedBox(
                                        height:
                                            Get.height > 300 ? barsheight : 0,
                                        child: Row(
                                          children: [
                                            Icon(
                                              MaterialCommunityIcons
                                                  .text_to_speech,
                                              size: iconsize(),
                                              color: MyTheme.colororigblue,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              title,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  wordSpacing: 2,
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      contentTitleTextsize(),
                                                  color: MyTheme.colorblack),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                      height: Get.height > 300 ? barsheight : 0,
                                      child: InkWell(
                                        onTap: () {
                                          AddContent(context,
                                              GetBuilder<UIPart>(
                                            builder: (_) {
                                              return Text(
                                                '설정',
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    wordSpacing: 2,
                                                    letterSpacing: 2,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: MyTheme.colorblack),
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            },
                                          ), node);
                                        },
                                        child: Icon(
                                          AntDesign.setting,
                                          size: iconsize(),
                                          color: MyTheme.colorblack,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Get.width)));
    }));
  }
}
