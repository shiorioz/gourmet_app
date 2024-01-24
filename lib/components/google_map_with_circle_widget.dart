import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_app/constant.dart';

class GoogleMapWithCircleWidget extends StatefulWidget {
  final Position currentLocation;
  final int range;

  const GoogleMapWithCircleWidget(
      {super.key, required this.currentLocation, required this.range});

  @override
  State<GoogleMapWithCircleWidget> createState() =>
      _GoogleMapWithCircleWidgetState();
}

class _GoogleMapWithCircleWidgetState extends State<GoogleMapWithCircleWidget> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng position = (LatLng(
        widget.currentLocation.latitude, widget.currentLocation.longitude));

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: Constant.zoomLevelMap[widget.range]!,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          scrollGesturesEnabled: true,
          // SingleChildScrollVer内でもスクロールできるようにする
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          circles: {
            Circle(
              circleId: const CircleId('Circle1'),
              center: position,
              radius: Constant.rangeMap[widget.range]!, //半径(m)
              strokeColor: Constant.red,
              fillColor: Constant.red.withOpacity(0.2),
              strokeWidth: 2,
            )
          },
        ));
  }
}
