import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

import '../common/common.dart';
import '../widgets/float_back_widget.dart';
import '../widgets/location_info_widget.dart';

class MapsScreen extends StatefulWidget {
  final Function() onBack;
  final Function(LatLng) onLocationPicked;

  const MapsScreen(
      {Key? key, required this.onBack, required this.onLocationPicked})
      : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _mapController;
  LocationData? _currentLocation;
  final Set<Marker> _markers = {};
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      _currentLocation = locationData;
      _selectedLocation = latLng;
      _markers.add(Marker(
          markerId: const MarkerId("currentLocation"), position: latLng));
    });

    _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15.0));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _onMapTap(LatLng latLng) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    geo.Placemark place = placemarks.first;

    setState(() {
      _selectedLocation = latLng;
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId("selectedLocation"),
        position: latLng,
        infoWindow: InfoWindow(
          title: place.street,
          snippet:
              "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}",
        ),
      ));
    });
  }

  void _onSelectLocation() {
    if (_selectedLocation != null) {
      widget.onLocationPicked(_selectedLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation != null
                    ? LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!)
                    : const LatLng(0, 0),
                zoom: 15,
              ),
              markers: _markers,
              onTap: _onMapTap,
              myLocationEnabled: true,
              padding: const EdgeInsets.only(
                  bottom: 186.0, top: 8.0),
            ),
            Positioned(
              bottom: 82,
              left: 16,
              right: 16,
              child: LocationInfoWidget(selectedLocation: _selectedLocation),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _selectedLocation != null ? _onSelectLocation : null,
                child: Text(
                  AppLocalizations.of(context)!.selectLocationButton,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatBackButton(onBack: widget.onBack),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      ),
    );
  }
}
