// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
//import 'dart:io';
//import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import '../Page/Insideview/homeview.dart';

class FromBackend extends GetxController {
  final connect = GetConnect();
  String status_pdf = '';
  String status_mp3 = '';
  String res = '';
  String playing = 'stop';
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int statuscode = 0;
  String responsebody = '';
  String ipAddress = 'default';

  void setstatus(String what, String where) {
    if (where == 'PDF') {
      status_pdf = what;
    } else {
      status_mp3 = what;
    }

    update();
    notifyChildrens();
  }

  void setcode(int what) {
    statuscode = what;

    update();
    notifyChildrens();
  }

  void setbody(String what) {
    responsebody = what;

    update();
    notifyChildrens();
  }

  // tosendfile
  // 서버에 pdf를 포함한 다양한 경로의 파일을 저장
  Future tosendfile() async {
    String starturl = GetPlatform.isWindows
        ? 'http://localhost:8000/convert/ConvertFile'
        : 'http://10.0.2.2:8000/convert/ConvertFile';
    var params = {
      'filePath': uiset.postfilepaths,
    };
    setstatus('', 'PDF');
    var response = await post(
      Uri.parse(starturl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Headers': '*'
      },
      body: jsonEncode(params),
    );
    uiset.setpdffilepath('', 0);
    uiset.setpdffilepath('', 1);
    await getRes();
    await FetchFullfile();
    /*Response response = await connect.request(starturl, 'get',
          headers: <String, String>{
            'Accept': 'application/json',
            'Access-Control-Allow-Headers': '*'
          },
          body: jsonEncode(params));*/
    /*Response response = await connect.post(
      starturl,
      jsonEncode(params),
      /*headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Headers': '*'
      },*/
    );*/
  }

  Future<void> getRes() async {
    var qrstring;
    Map<String, String> parameter = {"fileName": uiset.filename};

    String starturl = GetPlatform.isWindows
        ? 'http://localhost:8000/convert/GetPath'
        : 'http://10.0.2.2:8000/convert/GetPath';
    qrstring = Uri(queryParameters: parameter);
    var queryUri = '$starturl$qrstring';
    var response = await get(
      Uri.parse(queryUri),
    );
    setcode(response.statusCode);
    setbody(response.body);
  }

  //mp3가 완성되면 아래 주석 해제후 다시 돌려볼 예정
  Future<void> FetchFullfile() async {
    var filepath, filebyte, mp3path, fileinfo;
    if (statuscode == 200 || statuscode == 201) {
      fileinfo = jsonDecode(responsebody);
      filepath = fileinfo[0]['pdfFilePath'];
      uiset.setpdffilepath(filepath, 1);
      //mp3path = fileinfo[0]['mp3FilePath'];
      //uiset.setmp3filepath(mp3path);
      setstatus('', 'PDF');
      //setstatus('', 'MP3');
    } else if (statuscode == 400 || statuscode == 450 || statuscode == 500) {
      setstatus('Bad Request', 'PDF');
      setstatus('Bad Request', 'MP3');
      uiset.setprocesslist(0);
    } else {
      setstatus('Server Not Exists', 'PDF');
      setstatus('Server Not Exists', 'MP3');
      uiset.setprocesslist(0);
    }
  }

  Future FetchPDFPath() async {
    var filebyte;

    if (statuscode == 200 || statuscode == 201) {
      bool isPDF = checkIfPDF(uiset.filepaths);

      if (isPDF) {
        // PDF 파일인 경우
        //await loadfile2_1(uiset.filepaths);
        uiset.setprocesslist(1);
      } else {
        // PDF 파일이 아닌 경우
      }

      return uiset.filepaths;
    } else if (statuscode == 400 || statuscode == 450 || statuscode == 500) {
      uiset.setprocesslist(0);
      return uiset.filepaths;
    } else {
      uiset.setprocesslist(0);
      return uiset.filepaths;
    }
  }

  /*loadfile2_1(String filePath) async {
    Uint8List? bytes;
    final file = File(filePath);
    bytes = await file.readAsBytes();
    uiset.setpdffilebytes(bytes);
  }*/

  Future setAudio(String status) async {
    //var filemp3;
    if (status == 'reset') {
      uiset.setmp3filepath('');
    } else {}

    /*filemp3 = await loadmp3File(uiset.mp3paths);
    if (filemp3 == null) {
      setstatus('Bad Request');
      setDuration(Duration.zero);
      setPosition(Duration.zero);
    } else {
      isplaying('stop');
      setDuration(Duration.zero);
      setPosition(Duration.zero);
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }*/
    isplaying('stop');
    setDuration(Duration.zero);
    setPosition(Duration.zero);
    if (uiset.mp3paths == '') {
    } else {
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }
  }

  // Fetchtextorvoice
  // 서버에서 mp3를 불러옴
  Future Fetchvoice() async {
    var filemp3;

    //uiset.setmp3filepath('C:/Users/chosungsu/Desktop/audio.mp3');
    filemp3 = await loadmp3File(uiset.mp3paths);
    if (filemp3 == null) {
      setstatus('Bad Request', 'MP3');
    } else {
      isplaying('stop');
      setstatus('', 'MP3');
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }
    return filemp3;
  }

  Future<AudioPlayer?> loadmp3File(String filePath) async {
    try {
      await player.setSourceDeviceFile(filePath);
      return player;
    } catch (e) {
      return null;
    }
  }

  void isplaying(String what) {
    playing = what;
    update();
    notifyChildrens();
  }

  void setDuration(Duration what) {
    duration = what;

    update();
    notifyChildrens();
  }

  void setPosition(Duration what) {
    position = what;

    update();
    notifyChildrens();
  }

  bool checkIfPDF(String filePath) {
    // 파일 경로에서 마지막 부분을 가져와서 '.' 문자로 분할합니다.
    List<String> pathSegments = filePath.split('.');
    String extension = pathSegments.last.toLowerCase(); // 확장자를 소문자로 변경

    // 확장자가 'pdf'인지 확인
    if (extension == 'pdf') {
      return true; // PDF 파일이 맞다면 true 반환
    } else {
      return false; // PDF 파일이 아니라면 false 반환
    }
  }
}
