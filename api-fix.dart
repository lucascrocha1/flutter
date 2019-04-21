import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiFix {
  final client = http.Client();
  final filePath = 'lib/base/api-service.dart';

  changeApiUrl() async {
    print('Getting url...');
    var url = await _getUrlNgrok() as String;
    print('Done, the ngrok is running at: ' + url);

    if (url.isEmpty) {
      print('Oops. Something went wrong. Please try again.');
      return;
    }

    print('Changing api-service url...');
    await _changeUrlFile(url);
    print('Done.');
  }

  _getFile() async {
    return await File(filePath).readAsString();
  }

  _writeFile(String file) async {
    await File(filePath).writeAsString(file);
  }

  _changeUrlFile(String url) async {
    var file = await _getFile();

    file = file.replaceAll(RegExp(r'[a-z0-9]+.ngrok.io'), url);

    await _writeFile(file);
  }

  _getResponse() async {
    var response = await client.get(_getApiUrl());
    return await jsonDecode(response.body) as Map<dynamic, dynamic>;
  }

  _getUrlNgrok() async {
    var response = await _getResponse();

    for (var item in response.keys) {
      if (response[item] is String || response[item].isEmpty) return null;

      for (var subItem in response[item]) {
        var url = subItem['public_url'];

        url = url.replaceAll('https://', '');
        url = url.replaceAll('http://', '');

        return url;
      }
    }
  }

  String _getApiUrl() {
    return Uri.decodeFull(
        Uri.http('localhost:4040', '/api/tunnels').toString());
  }

  start() async {
    print('Starting ngrok...');

    await Process.start(
            'ngrok http -host-header=localhost https://localhost:44349', [''],
            runInShell: true)
        .then((result) {
      changeApiUrl();
    });
  }
}

main() {
  try {
    ApiFix().start();
  } catch (e) {
    print('Oops. Something went wrong. Please try again.');
  }
}
