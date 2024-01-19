import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_app/components/text_widget.dart';
import 'package:gourmet_app/constant.dart';
import 'package:gourmet_app/models/genre_model.dart';
import 'package:gourmet_app/models/shop_model.dart';
import 'package:gourmet_app/services/gourmet_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ShopListPage extends StatefulWidget {
  final Position currentPosition;
  final int range;
  final List<Genre> genres;

  const ShopListPage({
    super.key,
    required this.currentPosition,
    required this.range,
    required this.genres,
  });

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  // ページングのコントローラー
  final _pagingController = PagingController<int, Shop>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchShops(
        _pagingController,
        pageKey,
        widget.currentPosition,
        widget.range,
        widget.genres,
      );
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: NormalTextComponent(viewText: 'GOURMET')),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NormalTextComponent(viewText: '現在地から${widget.range}m'),
                // NormalTextComponent(
                //     viewText:
                //         'ジャンル：${widget.genres.map((e) => e.name).join(',')}'),
                // 検索結果の表示
                Expanded(
                  child: PagedListView<int, Shop>(
                    pagingController: _pagingController,
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    builderDelegate: PagedChildBuilderDelegate<Shop>(
                      itemBuilder: (context, item, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              // 枠線
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Constant.darkGray,
                                  width: 0.6,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // 画像
                              leading: Image.network(item.image),
                              // TODO: remove index
                              trailing: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              // 店舗名
                              title: Text(item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              // 情報
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      // マップアイコン
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 6),
                                                child: Icon(
                                                  FontAwesomeIcons.trainSubway,
                                                  size: 16,
                                                  color: Constant.darkGray,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: item.stationName,
                                              style: const TextStyle(
                                                color: Constant.darkGray,
                                              ),
                                            ),
                                          ],
                                          style: const TextStyle(
                                            color: Constant.darkGray,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
