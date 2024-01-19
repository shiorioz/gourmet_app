import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:gourmet_app/env/env.dart';
import 'package:gourmet_app/models/genre_model.dart';
import 'package:gourmet_app/models/shop_model.dart';

import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:xml/xml.dart';

// ジャンルを取得する非同期通信
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
    } else {
      // エラーメッセージ取得
      final message =
          json.decode(response.body)['results']['error'][0]['message'];
      return Future.error(message);
    }
  } catch (e) {
    return Future.error('Faild to load genres');
  }
}

// 条件が一致する店舗を取得する非同期通信
Future<void> fetchShops(PagingController pagingController, int pageKey,
    Position currentPosition, int range, List<Genre> genres) async {
  // 1ページあたりの取得件数
  const perPage = 20;

  // Positionから緯度経度を取得
  final latitude = currentPosition.latitude;
  final longitude = currentPosition.longitude;

  // ジャンルのcodeをカンマ区切りで取得
  final genreCodes = genres.map((e) => e.code).join(',');

  try {
    final url = Uri.parse(
        'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=${Env.key}&lat=${latitude}&lng=${longitude}&range=${range}&genre=${genreCodes}&count=${perPage}&start=${(pageKey - 1) * perPage + 1}&format=json');
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // レスポンスのbodyを取得する
      final body = json.decode(response.body);

      // レスポンスの中のresultsの中のshopの中身を取得する
      final results = body['results']['shop'];

      // resultsの中身をShopクラスに変換する
      final shops = results.map<Shop>((shop) {
        return Shop.fromJson(shop);
      }).toList();

      // ページが最後かどうかを判定する
      // result_returnedをintに変換
      final newShopCount = int.parse(body['results']['results_returned']);
      final isLastPage = newShopCount < perPage && pageKey != 1;
      if (isLastPage) {
        // ページが最後の場合はページングを終了する
        return pagingController.appendLastPage(shops);
      } else {
        // ページが最後でない場合は次のページを読み込む
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(shops, nextPageKey);
      }
    } else {
      // エラーメッセージ取得
      final message =
          json.decode(response.body)['results']['error'][0]['message'];
      return Future.error(message);
    }
  } catch (e) {
    return Future.error('Faild to load shops: $e');
  }
}
