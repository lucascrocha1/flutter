import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String api = '8b6ec71b.ngrok.io';
  final client = http.Client();

  get(String url, Map query) async {
    url += _getUrlQuery(query);

    var response = await client.get(_getApiUrl(url), headers: _getHeaders()); 

    if (response != null && response.body.isNotEmpty)
      return json.decode(response.body);
  }

  post(String url, Map body) async {
    var response = await client.post(_getApiUrl(url), body: jsonEncode(body), headers: _getHeaders());
    
    if (response != null && response.body.isNotEmpty)
      return json.decode(response.body);
  }

  put(String url, Map body) async {
    var response = await client.put(_getApiUrl(url), body: jsonEncode(body), headers: _getHeaders());
    
    if (response != null && response.body.isNotEmpty)
      return json.decode(response.body);
  }

  delete(String url, Map body) async {
    url += _getUrlQuery(body);

    var response = await client.delete(_getApiUrl(url), headers: _getHeaders());

    if (response != null && response.body.isNotEmpty)
      return json.decode(response.body);
  }

  _getHeaders() {
    return { 'Accept': 'application/json', 'Content-Type': 'application/json' };
  }

  _getUrlQuery(Map query) {
    var queryUrl = '';

    for (var item in query.keys) {
      if (item == null)
        continue;

      if (queryUrl.indexOf('?') < 0)
        queryUrl += '?';
      else
        queryUrl += '&';

      queryUrl += item + '=' + query[item].toString();
    }

    return queryUrl;
  }

  String _getApiUrl(String url) {
    return Uri.decodeFull(Uri.https(api, url).toString());
  }
}