// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeAlertDialog extends StatelessWidget {
  final Function(MapType) onMapTypeSelected;

  const MapTypeAlertDialog({
    required this.onMapTypeSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Map Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Normal'),
            onTap: () {
              onMapTypeSelected(MapType.normal);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Satellite'),
            onTap: () {
              onMapTypeSelected(MapType.satellite);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Terrain'),
            onTap: () {
              onMapTypeSelected(MapType.terrain);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Hybrid'),
            onTap: () {
              onMapTypeSelected(MapType.hybrid);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
