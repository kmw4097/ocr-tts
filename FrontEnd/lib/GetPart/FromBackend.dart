// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Page/Insideview/homeview.dart';

class FromBackend extends GetxController {
  final connect = GetConnect();
  String status = '';
  String res = '';
  String playing = 'stop';
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  void setstatus(String what) {
    status = what;

    update();
    notifyChildrens();
  }

  // tosendfile
  // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
  // 서버에 pdf를 포함한 다양한 경로의 파일을 저장
  Future tosendfile() async {
    // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
    String starturl = GetPlatform.isWeb
        ? 'http://localhost:8000/topdf'
        : 'http://10.0.2.2:8000/topdf';
    var params = {
      //'originalpath': uiset.filebytes,
      'originalpath': uiset.filepaths,
    };
    status = '';
    Response response = await connect.request(starturl, 'get',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Headers': '*'
        },
        body: jsonEncode(params));
    uiset.setloading(true, 0);
    return response.body;
  }

  // Fetchfile
  // 아래의 경로는 백엔드에서 결과값 경로로 지정한 경로로 수정...
  // 서버에서 pdf 파일, txt, mp3의 저장된 경로를 딕셔너리상태로 불러옴
  Stream Fetchfile() async* {
    var filepath, filebyte, txtpath, mp3path;
    String starturl = GetPlatform.isWeb
        ? 'http://localhost:8000/topdf'
        : 'http://10.0.2.2:8000/topdf';
    Response response = await connect.get(starturl);
    response = await connect.get(starturl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      status = '';
      filebyte = await loadfile2_1(response.body[0]);
      txtpath = response.body[1];
      mp3path = response.body[2];
      uiset.setpdffilebytes(filebyte);
      uiset.settxtfilepath(txtpath);
      uiset.setmp3filepath(mp3path);

      yield filebyte;
    } else if (response.statusCode == 500) {
      status = 'Bad Request';
      uiset.setprocesslist(0);
    } else if (response.statusCode == null) {
      status = 'Server Not Exists';
      uiset.setprocesslist(0);
    }
    uiset.setloading(false, 0);

    update();
    notifyChildrens();
    yield null;
  }

  Future<Uint8List?> loadfile2_1(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        Uint8List bytes = await file.readAsBytes();
        return bytes;
      }
    } catch (e) {
      print("Error loading file as bytes: $e");
    }
    return null;
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
  Future Fetchtext() async {
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
  }

  Future setAudio() async {
    var filemp3;
    uiset.setmp3filepath('');
    filemp3 = await loadmp3File(uiset.mp3paths);
    if (filemp3 == null) {
      setstatus('Bad Request');
    } else {
      isplaying('stop');
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }
  }

  // Fetchtextorvoice
  // 서버에서 텍스트를 불러옴
  Future Fetchvoice() async {
    var filemp3;
    uiset.setmp3filepath('C:/Users/chosungsu/Desktop/audio.mp3');
    //
    filemp3 = await loadmp3File(uiset.mp3paths);
    if (filemp3 == null) {
      setstatus('Bad Request');
    } else {
      isplaying('stop');
      player.setReleaseMode(ReleaseMode.loop);
      await player.setSourceDeviceFile(uiset.mp3paths);
    }
    uiset.setloading(false, 0);
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
