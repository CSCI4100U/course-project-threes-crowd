import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class EventMap extends StatefulWidget {
  EventMap({Key? key, this.loc, this.current_loc}) : super(key: key);

  LatLng? loc;
  Position? current_loc;

  @override
  State<EventMap> createState() => _EventMapState();
}

<<<<<<< HEAD
class _EventMapState extends State<EventMap> with TickerProviderStateMixin{

  var currentLocation;
=======
class _EventMapState extends State<EventMap> with TickerProviderStateMixin {
  var currentLocation = AppConstants.myLocation;
>>>>>>> 36f2e7354b71fd9a5fa023fb3d910778533b745a

  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    currentLocation = LatLng(widget.current_loc!.latitude, widget.current_loc!.longitude);

=======
>>>>>>> 36f2e7354b71fd9a5fa023fb3d910778533b745a
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then((LocationPermission permission) {
      print("Check Location Permission: $permission");
    });

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen(_updateLocationStream);

    return Scaffold(
      appBar: AppBar(
        title: Text('Where?'),
        actions: [
          IconButton(
              onPressed: () {
                _animatedMapMove(currentLocation, 13);
              },
              icon: const Icon(Icons.gps_fixed))
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 20,
              zoom: 16,
              center: widget.loc,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: AppConstants.mapBoxStyleId,
              ),
<<<<<<< HEAD
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: widget.loc!, 
                    builder: (context){
                          return Container(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.location_on,
                              color: Colors.blue),
                              iconSize: 30,
                            ),
                          );
                        }
                  ),
                  Marker(
                    point: LatLng(widget.current_loc!.latitude, widget.current_loc!.longitude), 
                    builder: (context){
                          return Container(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.location_on,
                              color: Colors.red),
                              iconSize: 30,
                            ),
                          );
                        }
                  ),
                ]
              )
=======
              MarkerLayerOptions(markers: [
                Marker(
                    point: widget.loc!,
                    builder: (context) {
                      return Container(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                          iconSize: 30,
                        ),
                      );
                    })
              ])
>>>>>>> 36f2e7354b71fd9a5fa023fb3d910778533b745a
            ],
          ),
        ],
      ),
    );
  }

  _updateLocationStream(Position userLocation) async {
    currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
