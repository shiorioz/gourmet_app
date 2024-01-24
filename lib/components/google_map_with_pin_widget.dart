import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWithPinWidget extends StatefulWidget {
  final LatLng targetPosition;
  const GoogleMapWithPinWidget({super.key, required this.targetPosition});

  @override
  State<GoogleMapWithPinWidget> createState() => _GoogleMapWithPinWidgetState();
}

class _GoogleMapWithPinWidgetState extends State<GoogleMapWithPinWidget> {
  late GoogleMapController mapController;

  Set<Marker> _createMarker() {
    return <Marker>{
      Marker(
        markerId: const MarkerId('marker1'),
        position: widget.targetPosition,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.targetPosition,
        zoom: 14.0,
      ),
      // SingleChildScrollVer内でもスクロールできるようにする
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
      },
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      markers: _createMarker(),
    );
  }
}
