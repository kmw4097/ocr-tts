// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import '../Page/Insideview/homeview.dart';

class FromBackend extends GetxController {
  final connect = GetConnect();
  String status = '';

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
      'originalpath': uiset.filebytes,
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
  // 서버에서 pdf 파일의 UInt8bytes를 불러옴
  Stream Fetchfile() async* {
    String starturl = GetPlatform.isWeb
        ? 'http://localhost:8000/topdf'
        : 'http://10.0.2.2:8000/topdf';
    Response response = await connect.get(starturl);
    response = await connect.get(starturl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      status = '';
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
    yield response.body;
  }

  // tosendpdf
  // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
  // 서버에 pdf를 보내 텍스트 및 보이스 변환
  Future tosendpdf() async {
    // 아래의 경로는 백엔드 파트에 기입한 경로대로 수정하는걸로...
    String starturl = GetPlatform.isWeb
        ? 'http://localhost:8000/tochange'
        : 'http://10.0.2.2:8000/tochange';
    var params = {
      'resultpath': uiset.filebytes,
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

  // Fetchtextorvoice
  // 아래의 경로는 백엔드에서 결과값 경로로 지정한 경로로 수정...
  // 서버에서 텍스트 및 보이스를 불러옴
  Stream Fetchtextorvoice(String what) async* {
    String starturl = GetPlatform.isWeb
        ? 'http://localhost:8000/tochange/$what'
        : 'http://10.0.2.2:8000/tochange/$what';
    Response response = await connect.get(starturl);
    response = await connect.get(starturl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      status = '';
    } else if (response.statusCode == 500) {
      status = 'Bad Request';
    } else if (response.statusCode == null) {
      status = 'Server Not Exists';
    }
    uiset.setloading(false, 0);
    update();
    notifyChildrens();
    yield response.body;
  }
}
