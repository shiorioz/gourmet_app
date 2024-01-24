import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet_app/components/app_bar_widget.dart';
import 'package:gourmet_app/components/google_map_with_circle_widget.dart';
import 'package:gourmet_app/components/text_widget.dart';
import 'package:gourmet_app/constant.dart';
import 'package:gourmet_app/models/genre_model.dart';
import 'package:gourmet_app/pages/shop_list_page.dart';
import 'package:gourmet_app/services/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/gourmet_api.dart';

class ShopSearchPage extends StatefulWidget {
  const ShopSearchPage({super.key});

  @override
  State<ShopSearchPage> createState() => _ShopSearchPageState();
}

class _ShopSearchPageState extends State<ShopSearchPage> {
  // ジャンルを取得する非同期通信
  late Future<List<Genre>> _fetchGenresFuture;
  // 取得したジャンルを格納するリスト
  List<Genre> genres = [];

  // 現在地を取得する非同期通信
  late Future<Position> _getCurrentPosition;
  // 現在地を格納する変数
  late Position currentPosition;

  // 選択したパラメータを格納する変数（初期値は1km）
  int selectedRange = 3;
  List<Genre> selectedGenres = [];

  // 最初のみ実行される
  @override
  void initState() {
    _fetchGenresFuture = _initGenres();
    _getCurrentPosition = _initCurrentPosition();
    super.initState();
  }

  Future<List<Genre>> _initGenres() async {
    return await fetchGenres();
  }

  Future<Position> _initCurrentPosition() async {
    return await getCurrentLocation();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // 検索ボタン押下時の処理（ShopListPageに遷移する）
  void _onPressedSearchButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShopListPage(
        currentPosition: currentPosition,
        range: selectedRange,
        genres: selectedGenres,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri.parse('http://webservice.recruit.co.jp/');
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Gourmet App',
        appBarColor: Constant.blue,
      ),
      // ジャンルを読み込んでから画面全体を表示する
      body: FutureBuilder<List<Genre>>(
          future: _fetchGenresFuture,
          builder: (context, snapshot) {
            // 読み込み中
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // 読み込みエラー
            if (!snapshot.hasData) {
              return const Center(
                child: Text('データが取得できませんでした'),
              );
            }
            genres = snapshot.data!;

            // 読み込み成功
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- 現在地表示部分
                  FutureBuilder(
                      future: _getCurrentPosition,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text('データが取得できませんでした'),
                          );
                        }
                        currentPosition = snapshot.data as Position;

                        return GoogleMapWithCircleWidget(
                          key: UniqueKey(),
                          currentLocation: currentPosition,
                          range: selectedRange,
                        );
                      }),
                  // --- 現在地表示部分ここまで
                  const SizedBox(height: 20),
                  // --- 検索項目入力部分
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 18,
                                  color: Constant.darkGray,
                                ),
                                SizedBox(width: 10),
                                NormalTextComponent(
                                  text: '現在地からの距離',
                                  textSize: 18,
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            _inputRangeWidget(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.utensils,
                              size: 18,
                              color: Constant.darkGray,
                            ),
                            SizedBox(width: 10),
                            NormalTextComponent(text: 'ジャンル', textSize: 18),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _inputGenreWidget(),
                      ],
                    ),
                  ),
                  // --- 検索項目入力部分ここまで
                  const SizedBox(height: 20),
                  _searchButtonWidget(),
                  const SizedBox(height: 20),
                  // クレジット表記
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Powered by',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constant.darkGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () => setState(() {
                                _launchInBrowser(toLaunch);
                              }),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 6),
                            foregroundColor: Constant.darkGray,
                          ),
                          child: const Text(
                            "ホットペッパーグルメ Webサービス",
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, -6),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  // クレジット表記ここまで
                  const SizedBox(height: 60),
                ],
              ),
            );
          }),
    );
  }

  // 現在地からの距離を選択するウィジェット
  Widget _inputRangeWidget() {
    return DropdownButton<int>(
      value: selectedRange,
      items: Constant.rangeMap.keys
          .map((key) => DropdownMenuItem(
                value: key,
                child: NormalTextComponent(
                  text: '${Constant.rangeMap[key]!.toInt()}m',
                  textSize: 18,
                ),
              ))
          .toList(),
      onChanged: (int? value) {
        setState(() {
          selectedRange = value!;
        });
      },
    );
  }

  // ジャンルを選択するウィジェット
  Widget _inputGenreWidget() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ジャンルのボタン
          Wrap(
            runSpacing: 16,
            spacing: 16,
            children: genres.map((genre) {
              final isSelected = selectedGenres.contains(genre);

              return InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: () {
                  if (selectedGenres.length == genres.length) {
                    // 押されたボタンのみを非選択状態にする
                    selectedGenres.remove(genre);
                  } else {
                    if (isSelected) {
                      selectedGenres.remove(genre);
                    } else {
                      selectedGenres.add(genre);
                    }
                  }
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    border: Border.all(
                      width: 1.8,
                      color: Constant.red,
                    ),
                    color: isSelected ? Constant.red : Colors.white,
                  ),
                  child: Text(
                    genre.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Constant.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // クリアボタン・全てボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.blue,
                ),
                onPressed: () {
                  setState(() {
                    selectedGenres.clear();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  child: Text('クリア',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.yellow,
                ),
                onPressed: () {
                  setState(() {
                    selectedGenres.clear();
                    selectedGenres.addAll(genres);
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  child: Text('全て',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  // クリア・検索ボタンウィジェット
  Widget _searchButtonWidget() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.red,
          ),
          onPressed: _onPressedSearchButton,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.magnifyingGlass,
                    size: 20, color: Colors.white),
                const SizedBox(width: 20),
                Text('SEARCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
