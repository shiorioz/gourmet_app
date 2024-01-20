import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_app/components/app_bar_widget.dart';
import 'package:gourmet_app/components/google_map_with_pin_widget.dart';
import 'package:gourmet_app/constant.dart';
import 'package:gourmet_app/models/shop_model.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: '',
        appBarColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 店舗画像
            Ink.image(
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
              image: NetworkImage(widget.shop.image),
            ),
            // テキスト
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 店舗名
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      widget.shop.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 住所
                  _detailContentWidget(
                    icon: FontAwesomeIcons.locationDot,
                    titleText: '住所',
                    contentText: widget.shop.address,
                  ),
                  const SizedBox(height: 8),
                  // GoogleMap
                  // これだけ右寄せ

                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: GoogleMapWithPinWidget(
                          targetPosition:
                              LatLng(widget.shop.lat, widget.shop.lng),
                        ),
                      ),
                    ),
                  ),
                  // アクセス
                  _detailContentWidget(
                    icon: FontAwesomeIcons.personWalking,
                    titleText: 'アクセス',
                    contentText: widget.shop.access,
                  ),
                  // 営業時間
                  _detailContentWidget(
                    icon: FontAwesomeIcons.clock,
                    titleText: '営業時間',
                    contentText: widget.shop.openTime,
                  ),
                  // 予算
                  _detailContentWidget(
                    icon: FontAwesomeIcons.sackDollar,
                    titleText: '予算',
                    contentText:
                        widget.shop.budget == '' ? '情報なし' : widget.shop.budget,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 詳細の内容のウイジェット
  Widget _detailContentWidget(
      {required IconData icon,
      required String titleText,
      required String contentText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Icon(
                  icon,
                  size: 18,
                  color: Constant.darkGray,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Constant.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contentText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Constant.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
