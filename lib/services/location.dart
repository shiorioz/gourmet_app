import "package:geolocator/geolocator.dart";

// デバイスの現在位置を取得する関数
Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうかを確認
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Future.error('位置情報サービスが有効になっていません');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // ユーザーに位置情報を許可してもらうよう促す
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 拒否された場合エラーを返す
      return Future.error('Location permissions are denied');
    }
  }

  // 永久に許可されていない場合はエラーを返す
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // 現在地を返す
  final position = await Geolocator.getCurrentPosition();

  return position;
}
