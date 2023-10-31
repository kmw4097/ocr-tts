// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
  // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
  // 서버에 pdf를 포함한 다양한 경로의 파일을 저장
  Future tosendfile() async {
    // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
    String starturl = GetPlatform.isWindows
        ? 'http://localhost:8000/convert/ConvertFile'
        : 'http://10.0.2.2:8000/convert/ConvertFile';
    var params = {
      //'originalpath': uiset.filebytes,
      'filePath': uiset.filepaths,
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
    FetchFullfile();
  }

  void FetchFullfile() async {
    var filepath, filebyte, txtpath, mp3path, fileinfo, qrstring;
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
    if (statuscode == 200 || statuscode == 201) {
      setstatus('', 'PDF');

      fileinfo = jsonDecode(responsebody);
      filebyte = fileinfo[0]['pdfFilePath'];
      uiset.setpdffilepath(filebyte);
    } else if (statuscode == 400 || statuscode == 450 || statuscode == 500) {
      setstatus('Bad Request', 'PDF');
      uiset.setprocesslist(0);
    } else {
      setstatus('Server Not Exists', 'PDF');
      uiset.setprocesslist(0);
    }
  }

  Future Fetchfile2() async {
    var filebyte, mp3path, fileinfo, qrstring;

    if (statuscode == 200 || statuscode == 201) {
      fileinfo = jsonDecode(responsebody);
      //filebyte = fileinfo[0]['pdfFilePath'];
      filebyte = await loadfile2_1(uiset.filepaths);

      //mp3path = fileinfo[0]['mp3FilePath'];
      uiset.setpdffilebytes(filebyte);
      setstatus('Go', 'PDF');
      //uiset.setmp3filepath(mp3path);
      uiset.setprocesslist(1);
      return filebyte;
    } else if (statuscode == 400 || statuscode == 450 || statuscode == 500) {
      uiset.setprocesslist(0);
      return filebyte;
    } else {
      uiset.setprocesslist(0);
      return filebyte;
    }
  }

  loadfile2_1(String filePath) async {
    Uint8List? bytes;
    final file = File(filePath);
    bytes = await file.readAsBytes();

    return bytes;
  }

  // tosendpdf
  // 서버에서 이미 받은 txt, mp3파일을 재확인 및 재할당함수로 수정함.
  void tosendfiles() async {
    uiset.settxtfilepath(uiset.txtpaths);
    uiset.setmp3filepath(uiset.mp3paths);
    //Fetchtext();

    update();
    notifyChildrens();
  }

  // Fetchtextorvoice
  // 서버에서 텍스트를 불러옴
  /*Future Fetchtext() async {
    var filetxt;
    filetxt = await readTextFromFile(uiset.txtpaths);
    uiset.settxtfilecontent(filetxt);
    if (filetxt == '') {
      setstatus('Bad Request');
    }

    return filetxt;
  }

  Future<String?> readTextFromFile(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents;
      } else {
        return filePath;
      }
    } catch (e) {
      return filePath;
    }
  }*/

  Future setAudio() async {
    //var filemp3;
    uiset.setmp3filepath('');
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
  // 서버에서 텍스트를 불러옴
  Future Fetchvoice() async {
    var filemp3;

    //uiset.setmp3filepath('C:/Users/chosungsu/Desktop/audio.mp3');
    filemp3 = await loadmp3File(uiset.mp3paths);
    if (filemp3 == null) {
      setstatus('Bad Request', 'MP3');
    } else {
      isplaying('stop');
      setstatus('Go', 'MP3');
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }
    return filemp3;
  }

  Future<AudioPlayer?> loadmp3File(String filePath) async {
    try {
      /*assetsAudioPlayer.open(
        Audio.file(filePath),
      );*/
      await player.setSourceDeviceFile(filePath);
      return player;
    } catch (e) {
      return null;
    }
  }

  String replaceurl(String what, int section) {
    var re_url;
    //textContent = what.replaceAll('\\', '\\\\');
    //textContent = what.replaceAll('\\\\', '/');
    re_url = what.replaceAll(r'\', '/');
    if (section == 0) {
      uiset.settxtfilepath(re_url);
    } else if (section == 1) {
      uiset.settxtfilepath(re_url);
    } else {
      uiset.setmp3filepath(re_url);
    }

    return re_url;
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
}
