import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gourmet_app/components/google_map_widget.dart';
import 'package:gourmet_app/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? selectedRange = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gourmet Search'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const GoogleMapWidget(),
              const SizedBox(height: 20),
              _inputRangeWidget(),
            ],
          ),
          // クリアボタン・検索ボタン
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.yellow,
                  ),
                  onPressed: () {},
                  child: const Text('クリア'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.red,
                  ),
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.search,
                            size: 20, color: Colors.white),
                        SizedBox(width: 16),
                        Text('SEARCH',
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 現在地からの距離を選択するウィジェット
  Widget _inputRangeWidget() {
    const Map<int, String> rangeMap = {
      1: '300m',
      2: '500m',
      3: '1km',
      4: '2km',
      5: '3km',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('現在地からの距離'),
        const SizedBox(width: 20),
        DropdownButton<int>(
          value: selectedRange,
          items: rangeMap.keys
              .map((key) => DropdownMenuItem(
                    value: key,
                    child: Text(rangeMap[key]!),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              // TODO: 現在地からの範囲(selectedRange)を次のページに渡す
              selectedRange = value;
            });
          },
        ),
      ],
    );
  }
}
