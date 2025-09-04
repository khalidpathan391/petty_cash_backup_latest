// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'package:place_picker_google/place_picker_google.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

class PlacePickerWidget extends StatelessWidget {
  final Function(LocationResult) onPlacePicked;

  const PlacePickerWidget({super.key, required this.onPlacePicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Pick Delivery Location"),
      onPressed: () {
        showPlacePicker(context);
      },
    );
  }

  void showPlacePicker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            // Removed usePinPointingSearch as it's not supported
            apiKey: 'AIzaSyDGzVH50GxKpAAU69gcux1_VMd45G1gJxc',
            onPlacePicked: (LocationResult result) {
              onPlacePicked(result);
              Navigator.of(context).pop();
            },
            enableNearbyPlaces: false,
            showSearchInput: true,
            initialLocation: const LatLng(29.378586, 47.990341),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              // controller.setMapStyle(null); // Optional: Apply a custom map style if needed
            },
            searchInputConfig: const SearchInputConfig(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: false,
              textDirection: TextDirection.ltr,
            ),
            searchInputDecorationConfig: const SearchInputDecorationConfig(
              hintText: "Search for a building, street or ...",
            ),
          );
        },
      ),
    );
  }
}
