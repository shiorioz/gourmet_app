import 'package:gourmet_app/env/env.dart';
import 'package:gourmet_app/models/genre_model.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

Future<List<Genre>> fetchGenres() async {
  try {
    final url = Uri.parse(
        'https://webservice.recruit.co.jp/hotpepper/genre/v1/?key=${Env.key}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // レスポンスはxml形式で来る
      final xml = XmlDocument.parse(response.body);

      final genres = xml.findAllElements('genre').map((node) {
        final code = node.findElements('code').first.innerText;
        final name = node.findElements('name').first.innerText;
        return Genre(code: code, name: name);
      }).toList();

      return genres;
    }
  } catch (e) {
    print(e);
    return Future.error('Faild to load genres');
  }

  return [];
}
