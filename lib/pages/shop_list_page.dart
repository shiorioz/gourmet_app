import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_app/components/app_bar_widget.dart';
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
        appBar: const AppBarWidget(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PagedListView<int, Shop>(
                    pagingController: _pagingController,
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    builderDelegate: PagedChildBuilderDelegate<Shop>(
                      // データがない場合
                      noItemsFoundIndicatorBuilder: (context) {
                        return _notFoundWidget();
                      },

                      // データがある場合
                      itemBuilder: (context, item, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            surfaceTintColor: Colors.white,
                            child: Column(
                              children: [
                                Ink.image(
                                  image: NetworkImage(item.image),
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 4),
                                          child: Column(
                                            children: [
                                              _iconTextWidget(
                                                  icon:
                                                      FontAwesomeIcons.utensils,
                                                  text: item.genre),
                                              const SizedBox(height: 4),
                                              _iconTextWidget(
                                                  icon: FontAwesomeIcons
                                                      .locationDot,
                                                  text: item.access),
                                              const SizedBox(height: 4),
                                              _iconTextWidget(
                                                  icon: FontAwesomeIcons
                                                      .sackDollar,
                                                  text: item.budget),
                                            ],
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // データがない場合のウィジェット
  Widget _notFoundWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 40,
            color: Constant.red,
          ),
          const SizedBox(height: 20),
          const NormalTextComponent(
            text: '条件に一致する店舗が見つかりませんでした',
            textSize: 16,
          ),
        ],
      ),
    );
  }

  // アイコンとテキストを横に並べたウィジェット
  Widget _iconTextWidget({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 14,
            color: Constant.darkGray,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Constant.darkGray,
            ),
          ),
        ),
      ],
    );
  }
}
