import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gourmet_app/components/google_map_widget.dart';
import 'package:gourmet_app/components/text_widget.dart';
import 'package:gourmet_app/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? selectedRange = 3;

  // クリアボタン押下時の処理
  void _onPressedClearButton() {
    setState(() {
      selectedRange = 3;
    });
  }

  // 検索ボタン押下時の処理
  void _onPressedSearchButton() {
    // TODO: selectedRangeを次のページに渡して遷移する
  }

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
              _inputRangeWidget()
            ],
          ),
          _searchButtonWidget()
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
        // const Text('現在地からの距離'),
        NormalTextComponent(viewText: '現在地からの距離'),
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
              selectedRange = value;
            });
          },
        ),
      ],
    );
  }

  // クリア・検索ボタン
  Widget _searchButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.yellow,
          ),
          onPressed: _onPressedClearButton,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text('クリア',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.red,
          ),
          onPressed: _onPressedSearchButton,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.magnifyingGlass,
                    size: 20, color: Colors.white),
                SizedBox(width: 16),
                Text('SEARCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
