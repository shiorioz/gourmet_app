import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_app/components/google_map_widget.dart';
import 'package:gourmet_app/components/text_widget.dart';
import 'package:gourmet_app/constant.dart';
import 'package:gourmet_app/models/genre_model.dart';
import 'package:gourmet_app/services/location.dart';

import '../services/gourmet_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ジャンルを取得する非同期通信
  late Future<List<Genre>> _fetchGenresFuture;
  // 取得したジャンルを格納するリスト
  List<Genre> genres = [];

  // 現在地を取得する非同期通信
  late Future<Position> _getCurrentPosition;
  // 現在地を格納する変数
  late Position currentPosition;

  // 選択したパラメータを格納する変数（初期値は1km）
  int? selectedRange = 3;
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

  // 検索ボタン押下時の処理
  void _onPressedSearchButton() {
    // TODO: selectedRange, selectedGenresを次のページに渡して遷移する
  }

  // クリアボタン押下時の処理
  void _onPressedClearButton() {
    selectedGenres = [];
    setState(() {});
  }

  // 全てボタン押下時の処理
  void _onPressedAllButton() {
    selectedGenres.addAll(genres);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text('Gourmet Search'),
      // ),
      // ジャンルを読み込んでから画面を表示する
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

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                        return GoogleMapWidget(
                          key: UniqueKey(),
                          currentLocation: currentPosition,
                          range: Constant.rangeMap[selectedRange]!,
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
                        _inputRangeWidget(),
                        const SizedBox(height: 20),
                        NormalTextComponent(viewText: 'ジャンル'),
                        const SizedBox(height: 20),
                        _inputGenreWidget(),
                      ],
                    ),
                  ),
                  // --- 検索項目入力部分ここまで
                  const SizedBox(height: 20),
                  _searchButtonWidget(),
                  const SizedBox(height: 60),
                ],
              ),
            );
          }),
    );
  }

  // 現在地からの距離を選択するウィジェット
  Widget _inputRangeWidget() {
    return Row(
      children: [
        NormalTextComponent(viewText: '現在地からの距離'),
        const SizedBox(width: 20),
        DropdownButton<int>(
          value: selectedRange,
          items: Constant.rangeMap.keys
              .map((key) => DropdownMenuItem(
                    value: key,
                    child: NormalTextComponent(
                        viewText: '${Constant.rangeMap[key]!.toInt()}m'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              selectedRange = value;
            });
          },
        ),
      ],
    );
  }

  // ジャンルを選択するウィジェット
  Widget _inputGenreWidget() {
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
              onPressed: _onPressedClearButton,
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
              onPressed: _onPressedAllButton,
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
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.magnifyingGlass,
                    size: 20, color: Colors.white),
                SizedBox(width: 20),
                Text('SEARCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
