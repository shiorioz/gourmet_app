import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_app/constant.dart';

class GoogleMapWithCircleWidget extends StatefulWidget {
  final Position currentLocation;
  final double range;

  const GoogleMapWithCircleWidget(
      {super.key, required this.currentLocation, required this.range});

  @override
  State<GoogleMapWithCircleWidget> createState() =>
      _GoogleMapWithCircleWidgetState();
}

class _GoogleMapWithCircleWidgetState extends State<GoogleMapWithCircleWidget> {
  late Position _currentLocation;
  late double _range;
  late GoogleMapController mapController;

  @override
  void initState() {
    _currentLocation = widget.currentLocation;
    _range = widget.range;
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng position =
        (LatLng(_currentLocation.latitude, _currentLocation.longitude));

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 14.0,
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
              radius: _range, //半径(m)
              strokeColor: Constant.red,
              fillColor: Constant.red.withOpacity(0.2),
              strokeWidth: 2,
            )
          },
        ));
  }
}
