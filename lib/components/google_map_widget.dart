import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final Position currentLocation;
  final double range;

  const GoogleMapWidget(
      {super.key, required this.currentLocation, required this.range});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
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
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          circles: {
            Circle(
              circleId: const CircleId('Circle1'),
              center: position,
              radius: _range, //半径(m)
              strokeColor: Colors.pink.withOpacity(0.8),
              fillColor: Colors.pink.withOpacity(0.2),
              strokeWidth: 2,
            )
          },
        ));
  }
}
