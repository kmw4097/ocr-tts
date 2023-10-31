// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dplit/GetPart/FromBackend.dart';
import 'package:dplit/GetPart/UIPart.dart';
import 'package:dplit/Tool/MyTheme.dart';
import 'package:dplit/Tool/TextSize.dart';
import 'package:dplit/Tool/WidgetStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'pdfview.dart';

final fb = Get.put(FromBackend());

home(
  context,
  maxHeight,
  maxWidth,
  scrollController,
  pdfViewerController,
  searchNode,
  isportrait,
) {
  List pageview = [
    view0(context, maxHeight, maxWidth, searchNode, pdfViewerController),
    view1(context, maxHeight, maxWidth, searchNode, pdfViewerController)
  ];
  return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: SingleChildScrollView(
          controller: scrollController, child: pageview[isportrait]));
}

// 세로 모드는 view0으로 통합
view0(
  context,
  maxHeight,
  maxWidth,
  searchNode,
  pdfViewerController,
) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      Searchview(context, maxHeight, maxWidth, searchNode, 0),
      const SizedBox(
        height: 20,
      ),
      PDFDashboard(
        context,
        maxHeight,
        maxWidth,
        searchNode,
        pdfViewerController,
        0,
      ),
      const SizedBox(
        height: 20,
      ),
      Settingview(context, maxHeight, maxWidth, searchNode, 0),
      const SizedBox(
        height: 20,
      ),
      //QAview()
    ],
  );
}

// 가로 모드는 view1로 통합
view1(context, maxHeight, maxWidth, searchNode, pdfViewerController) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        flex: 2,
        child: PDFDashboard(
          context,
          maxHeight,
          maxWidth,
          searchNode,
          pdfViewerController,
          1,
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Flexible(
          flex: 1,
          child: Container(
            constraints: BoxConstraints.expand(height: maxHeight - 50),
            child: Column(
              children: [
                Searchview(context, maxHeight, maxWidth, searchNode, 1),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child:
                      Settingview(context, maxHeight, maxWidth, searchNode, 1),
                )
              ],
            ),
          ))

      //QAview()
    ],
  );
}

// 뷰에 포함되어야 하는 작은 뷰 :
// pdf를 불러오는 절반의 대시보드(바텀뷰로 pdf를 파일 또는 링크로 불러옴과 동시에 OCR을 진행하게 로딩뷰를 보여줌),
// TTS + QA(추후 진행이라 주석처리)를 실행하는 버튼뷰,
// TTS를 실행해주는 목소리를 선택하거나 속도 조절하는 설정칸,
// QA결과뷰
Searchview(context, maxHeight, maxWidth, searchNode, section) {
  var filesomething, filepath, filename;
  List files = [];
  return ContainerDesign(
      color: MyTheme.colorWhite,
      type: 0,
      child: SizedBox(
          height: section == 0 ? 100 : 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Divider(height: 30, thickness: 2, color: uiset.backgroundcolor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 2,
                      child: SizedBox(
                        child: ContainerDesign(
                          color: uiset.isstart
                              ? MyTheme.colororigred
                              : MyTheme.colororigblue,
                          type: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (uiset.processlist[0] != true) {
                                    IconSnackBar.show(
                                        context: context,
                                        snackBarType: SnackBarType.fail,
                                        label: '파일 변경을 원하시면 우측 x표시를 클릭해주세요!');
                                  } else {
                                    uiset.setclickedpdf(false);
                                    fb.setstatus('', 'PDF');
                                    fb.setstatus('', 'MP3');
                                    // 이 코드는 새로 변경된 부분으로
                                    // 서버로 보내기 전 기존 로컬 파일경로를 받아옴.
                                    try {
                                      files = await loadfile3();
                                    } catch (e) {
                                      print(e);
                                    }
                                    //files = await loadfile3();
                                    if (files[0] != null) {
                                      uiset.setpdffilename(files[0]);
                                      uiset.setpdffilepath(files[1]);
                                      uiset.setclickwhat(1);
                                      uiset.setprocesslist(0);
                                      // 이 부분부터는 현재는 pdf, xlsx, docs 등을 받아
                                      // 처리를 하고 있고 백엔드 서버로 filesomething값을
                                      // 보내어 다시 리턴(온전한 pdf값으로)받도록 하는 로직이 필요하다.
                                      fb.tosendfile();
                                    } else {
                                      uiset.setclickwhat(0);
                                      uiset.setprocesslist(0);
                                    }
                                    /*if (GetPlatform.isMobile) {
                                      filesomething = await loadfile1();
                                    } else {
                                      filesomething = await loadfile2();
                                    }
                                    if (filesomething != null) {
                                      if (GetPlatform.isMobile) {
                                        uiset.setpdffilepath(filesomething);
                                      } else {
                                        uiset.setpdffilebytes(filesomething);
                                      }
                                      uiset.setclickwhat(1);
                                      uiset.setprocesslist(1);
                                      // 이 부분부터는 현재는 pdf, xlsx, docs 등을 받아
                                      // 처리를 하고 있고 백엔드 서버로 filesomething값을
                                      // 보내어 다시 리턴(온전한 pdf값으로)받도록 하는 로직이 필요하다.
                                      fb.tosendfile();
                                    }*/
                                  }

                                  /*AddContent(
                          context,
                          Text(
                            '업로드',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                wordSpacing: 2,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: MyTheme.colorblack),
                            overflow: TextOverflow.ellipsis,
                          ),
                          searchNode);*/
                                },
                                child: SizedBox(
                                  child: Icon(
                                    AntDesign.upload,
                                    size: 25,
                                    color: uiset.processlist[0] == true
                                        ? MyTheme.colorWhite
                                        : MyTheme.colorgreyshade,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (uiset.processlist[1] != true) {
                                    if (fb.status_pdf == 'Bad Request' ||
                                        fb.status_pdf == 'Server Not Exists') {
                                      IconSnackBar.show(
                                          context: context,
                                          snackBarType: SnackBarType.fail,
                                          label:
                                              '예기치 못한 에러로 인해 사용불가상태입니다! 다시 시도해주세요');
                                    } else {
                                      IconSnackBar.show(
                                          context: context,
                                          snackBarType: SnackBarType.fail,
                                          label:
                                              '먼저 파일을 업로드하셔야 사용가능상태로 전환됩니다!');
                                    }
                                    uiset.setstart(false);
                                  } else {
                                    uiset.setstart(!uiset.isstart);
                                    uiset.settxtfilecontent('');
                                    fb.setAudio();
                                    fb.isplaying('stop');
                                    fb.player.stop();
                                    fb.tosendfiles();
                                  }
                                },
                                child: Text(
                                  uiset.isstart ? '변환중지' : '변환시작',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    wordSpacing: 2,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: uiset.processlist[1] == true
                                        ? MyTheme.colorWhite
                                        : MyTheme.colorgreyshade,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: InkWell(
                        onTap: () {
                          uiset.setprocesslist(0);
                          uiset.filepaths = '';
                          uiset.filebytes = Uint8List(1);
                          fb.setstatus('', 'PDF');
                          fb.setstatus('', 'MP3');
                          uiset.setclickedpdf(false);
                          fb.setAudio();
                          fb.isplaying('stop');
                          fb.player.stop();
                          uiset.setstart(false);
                          //uiset.filebytes = '';
                        },
                        child: SizedBox(
                          child: Icon(
                            MaterialIcons.clear,
                            size: iconsize(),
                            color: MyTheme.colorblack,
                          ),
                        )),
                  )
                ],
              )
            ],
          )));
}

PDFDashboard(
  context,
  maxHeight,
  maxWidth,
  searchNode,
  pdfViewerController,
  section,
) {
  return ContainerDesign(
      color: MyTheme.colorWhite,
      type: 0,
      child: GetBuilder<UIPart>(builder: (_) {
        return SizedBox(
          height: section == 0
              ? (maxHeight * 0.4 > 500 ? maxHeight * 0.4 : 500)
              : maxHeight - 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '뷰어',
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        wordSpacing: 2,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize(),
                        color: MyTheme.colorblack),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          pdfViewerController.zoomLevel -= 1;
                        },
                        child: Icon(
                          Feather.zoom_out,
                          size: iconsize(),
                          color: MyTheme.colorgrey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pdfViewerController.zoomLevel += 1;
                        },
                        child: Icon(
                          Feather.zoom_in,
                          size: iconsize(),
                          color: MyTheme.colorblack,
                        ),
                      )
                    ],
                  )
                ],
              ),
              // 선택한 파일이 있는 경우 PDF를 보여줍니다.
              uiset.isclikedpdf
                  ? Flexible(
                      fit: FlexFit.tight,
                      child: uiset.clickwhat == 1
                          ? (GetPlatform.isWeb ||
                                  GetPlatform.isWindows ||
                                  GetPlatform.isMacOS
                              //? uiset.filebytes != Uint8List(1)
                              ? FutureBuilder(
                                  future: fb.Fetchfile2(),
                                  builder: (context, snapshot) {
                                    return GetBuilder<FromBackend>(
                                        builder: (_) {
                                      if (fb.status_pdf == 'Go') {
                                        return snapshot.hasData
                                            ? (snapshot.data is Uint8List
                                                ? SfPdfViewer.memory(
                                                    snapshot.data as Uint8List,
                                                    controller:
                                                        pdfViewerController,
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '데이터가 전달되지 않았습니다.',
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: MyTheme
                                                                .colorgrey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    ],
                                                  ))
                                            : SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color:
                                                          MyTheme.colororigblue,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      '서버로부터 불러오는 중입니다. 잠시만 기다려주십시오.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          wordSpacing: 2,
                                                          letterSpacing: 2,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize:
                                                              contentsmallTextsize(),
                                                          color: MyTheme
                                                              .colorgreyshade),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      } else if (snapshot.data == null) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '데이터가 전달되지 않았습니다.',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: MyTheme.colorgrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        );
                                      } else {
                                        return SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: MyTheme.colororigblue,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                '서버로부터 불러오는 중입니다. 잠시만 기다려주십시오.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    wordSpacing: 2,
                                                    letterSpacing: 2,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        contentsmallTextsize(),
                                                    color:
                                                        MyTheme.colorgreyshade),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    });
                                  },
                                )
                              : SfPdfViewer.file(
                                  File(uiset.filepaths),
                                  controller: pdfViewerController,
                                ))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  section == 0
                                      ? '상단의 업로드 버튼으로\n파일 업로드 해주세요'
                                      : '우측의 업로드 버튼으로\n파일 업로드 해주세요',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyTheme.colorgrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize()),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ))
                  : Flexible(
                      fit: FlexFit.tight,
                      child: GetBuilder<UIPart>(
                        builder: (_) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                section == 0
                                    ? '상단의 업로드 버튼으로\n파일 업로드 해주세요'
                                    : '우측의 업로드 버튼으로\n파일 업로드 해주세요',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.colorgrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize()),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          );
                        },
                      )), // 선택한 파일이 PDF가 아닌 경우 빈 컨테이너 표시
            ],
          ),
        );
      }));
}

Settingview(context, maxHeight, maxWidth, searchNode, section) {
  var txtpath;
  return ContainerDesign(
      color: MyTheme.colorWhite,
      type: 0,
      child: SizedBox(
        height: section == 0 ? 500 : maxHeight - 100 - 150,
        child: Column(
          children: [
            GetBuilder<UIPart>(builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*InkWell(
                    onTap: () {
                      uiset.setdrawerlist(0);
                    },
                    child: Text(
                      'To-PDF',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: uiset.drawerlist[0] == true
                              ? MyTheme.colorblack
                              : MyTheme.colorgrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),*/
                  InkWell(
                    onTap: () {
                      uiset.setdrawerlist(0);
                    },
                    child: Text(
                      'To-Voice',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: uiset.drawerlist[0] == true
                              ? MyTheme.colorblack
                              : MyTheme.colorgrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
            Divider(
              height: 30,
              thickness: 2,
              color: uiset.backgroundcolor,
            ),
            Flexible(
                fit: FlexFit.tight,
                child: GetBuilder<UIPart>(
                  builder: (_) {
                    return uiset.isstart
                        ? Viewdrawerbox(uiset.drawerlist.indexOf(true))
                        : NoneViewBox(context, uiset.drawerlist.indexOf(true));
                  },
                ))
          ],
        ),
      ));
}

//QAview(){}
Viewdrawerbox(section) {
  // 각 sizedbox는 스크롤이 되도록 수정해야 함
  // audio를 재생하는 UI와 로직을 재정비해야 함.
  /*SizedBox(child: GetBuilder<FromBackend>(builder: (_) {
          return FutureBuilder(
            future: fb.Fetchtext(),
            builder: (context, snapshot) {
              if (snapshot.data != '') {
                return Text(
                  uiset.txtcontents,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    wordSpacing: 2,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: MyTheme.colorblack,
                  ),
                );
              } else {
                if (fb.status == 'Bad Request' ||
                    fb.status == 'Server Not Exists') {
                  return SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          AntDesign.frowno,
                          color: Colors.red,
                          size: 30,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          fb.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              wordSpacing: 2,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: MyTheme.colororigred),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'x버튼을 클릭하여 재시도해주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              wordSpacing: 2,
                              letterSpacing: 2,
                              fontWeight: FontWeight.normal,
                              fontSize: contentsmallTextsize(),
                              color: MyTheme.colorgreyshade),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: MyTheme.colororigblue,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '서버로부터 불러오는 중입니다. 잠시만 기다려주십시오.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              wordSpacing: 2,
                              letterSpacing: 2,
                              fontWeight: FontWeight.normal,
                              fontSize: contentsmallTextsize(),
                              color: MyTheme.colorgreyshade),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          );
        }))*/
  return SizedBox(
    child: GetBuilder<FromBackend>(builder: (_) {
      return FutureBuilder(
        future: fb.Fetchvoice(),
        builder: (context, snapshot) {
          if (snapshot.hasData || fb.status_mp3 == 'Go') {
            return SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Slider(
                    min: 0,
                    max: fb.duration.inSeconds.toDouble(),
                    value: fb.position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await fb.player.seek(position);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(fb.position),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: MyTheme.colorblack),
                      ),
                      Text(
                        formatTime(fb.duration),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: MyTheme.colorblack),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*InkWell(
                              onTap: () {
                                IconSnackBar.show(
                                    context: context,
                                    snackBarType: SnackBarType.fail,
                                    label: '상단의 변환과정을 먼저 수행하셔야 합니다.');
                              },
                              child: Icon(
                                Feather.rotate_ccw,
                                color: MyTheme.colorblack,
                                size: iconsize(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),*/
                      fb.playing == 'play' ||
                              fb.playing == 'pause' ||
                              fb.playing == 'resume'
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    fb.isplaying('stop');
                                    await fb.player.stop();
                                  },
                                  child: GetBuilder<FromBackend>(builder: (_) {
                                    return Icon(
                                      Ionicons.stop,
                                      color: MyTheme.colororigred,
                                      size: largeiconsize(),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (fb.playing == 'pause') {
                                      fb.isplaying('resume');
                                      await fb.player.resume();
                                    } else {
                                      fb.isplaying('pause');
                                      await fb.player.pause();
                                    }
                                  },
                                  child: GetBuilder<FromBackend>(builder: (_) {
                                    return Icon(
                                      fb.playing == 'pause'
                                          ? AntDesign.play
                                          : AntDesign.pausecircle,
                                      color: MyTheme.colororigblue,
                                      size: largeiconsize(),
                                    );
                                  }),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () async {
                                fb.isplaying('play');
                                await fb.player.play(UrlSource(uiset.mp3paths));

                                /*IconSnackBar.show(
                                context: context,
                                snackBarType: SnackBarType.fail,
                                label: '상단의 변환과정을 먼저 수행하셔야 합니다.');*/
                              },
                              child: GetBuilder<FromBackend>(builder: (_) {
                                return Icon(
                                  AntDesign.play,
                                  color: MyTheme.colororigblue,
                                  size: largeiconsize(),
                                );
                              }),
                            ),
                      /*const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                IconSnackBar.show(
                                    context: context,
                                    snackBarType: SnackBarType.fail,
                                    label: '상단의 변환과정을 먼저 수행하셔야 합니다.');
                              },
                              child: Icon(
                                Feather.rotate_cw,
                                color: MyTheme.colorblack,
                                size: iconsize(),
                              ),
                            ),*/
                    ],
                  ),
                )
              ],
            ));
          } else {
            if (fb.status_mp3 == 'Bad Request' ||
                fb.status_mp3 == 'Server Not Exists') {
              return SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      AntDesign.frowno,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      fb.status_mp3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: MyTheme.colororigred),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'x버튼을 클릭하여 재시도해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                          fontWeight: FontWeight.normal,
                          fontSize: contentsmallTextsize(),
                          color: MyTheme.colorgreyshade),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: MyTheme.colororigblue,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '서버로부터 불러오는 중입니다. 잠시만 기다려주십시오.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                          fontWeight: FontWeight.normal,
                          fontSize: contentsmallTextsize(),
                          color: MyTheme.colorgreyshade),
                    ),
                  ],
                ),
              );
            }
          }
        },
      );
    }),
  );
}

NoneViewBox(context, section) {
  /**
   * Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '상단의 변환과정을 먼저 수행하셔야 합니다.',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: MyTheme.colorgrey,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
   */
  return SizedBox(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Slider(
          min: 0,
          max: 1,
          value: fb.position.inSeconds.toDouble(),
          onChanged: (value) async {
            //final position = Duration(seconds: value.toInt());
            //await fb.player.seek(position);
          }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatTime(fb.position),
              textAlign: TextAlign.center,
              style: TextStyle(
                  wordSpacing: 2,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: MyTheme.colorblack),
            ),
            Text(
              formatTime(fb.duration),
              textAlign: TextAlign.center,
              style: TextStyle(
                  wordSpacing: 2,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: MyTheme.colorblack),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                IconSnackBar.show(
                    context: context,
                    snackBarType: SnackBarType.fail,
                    label: '상단의 변환과정을 먼저 수행하셔야 합니다.');
              },
              child: GetBuilder<FromBackend>(builder: (_) {
                return Icon(
                  AntDesign.play,
                  color: MyTheme.colororigblue,
                  size: largeiconsize(),
                );
              }),
            ),
          ],
        ),
      ),
    ],
  ));
}

formatTime(Duration durationone) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(durationone.inHours);
  final minutes = twoDigits(durationone.inMinutes.remainder(60));
  final seconds = twoDigits(durationone.inSeconds.remainder(60));

  return [
    if (durationone.inHours > 0) hours,
    minutes,
    seconds,
  ].join(' : ');
}
