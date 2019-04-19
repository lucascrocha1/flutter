import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiNgrokFix {
  final client = http.Client();
  final filePath = './lib/base/api-service.dart';

  changeApiUrl() async {
    print('Getting url...');
    var url = await _getUrlNgrok();
    print('Done, the url is running at: ' + url);

    print('Changing api-service url...');
    await _changeUrlFile(url);
    print('Done.');
  }

  _changeUrlFile(String url) async {
    var file = await File(filePath).readAsString();
    var newFile = file.replaceAll(RegExp(r'[a-z0-9]+.ngrok.io'), url);
    await File(filePath).writeAsString(newFile);
  }

  _getUrlNgrok() async {
    var response = await client.get(_getApiUrl());
    var data = await jsonDecode(response.body) as Map<dynamic, dynamic>;

    var url = '';

    for (var item in data.keys) {
      for (var subItem in data[item]) {
        url = subItem['public_url'];
        break;
      }

      if (url != null) 
        break;
    }

    url = url.replaceAll('https://', '');
    url = url.replaceAll('http://', '');

    return url;
  }

  String _getApiUrl() {
    return Uri.decodeFull(Uri.http('localhost:4040', '/api/tunnels').toString());
  }
}

main() async {
  try {
    await ApiNgrokFix().changeApiUrl();
  } catch (e) {
    print('Check if ngrok is running.');
  }
}
