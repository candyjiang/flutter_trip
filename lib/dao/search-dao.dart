import 'dart:convert';
import 'package:flutter_trip/model/search-model.dart';
import 'package:http/http.dart' as http;

const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchDao {
  static Future<SearchModel> fetch(String url) async {
    final response = await http.get(URL + url);
    if (response.statusCode == 200) {
      // fix 中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      Map<String, dynamic> result = json.decode(utf8decoder.convert(response.bodyBytes));
      return SearchModel.fromJson(result);
    } else {
      throw Exception('请求失败');
    }
  }
}
