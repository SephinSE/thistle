import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thistle/app_state.dart';

class ThistleMapPage extends StatefulWidget {
  const ThistleMapPage({super.key});

  @override
  State<ThistleMapPage> createState() => _ThistleMapPageState();
}

class _ThistleMapPageState extends State<ThistleMapPage> {
  // Initial position for the map camera
  static const LatLng _pGooglePlex = LatLng(10.043074979535975, 76.32427666764684);

  final Completer<GoogleMapController> _controller = Completer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BitmapDescriptor? customIcon;  // Custom icon for map markers
  final List<Marker> _markers = <Marker>[];  // List of markers to display on the map

  @override
  void initState() {
    super.initState();
    _initializeMap();  // Initialize map resources
  }

  // Initialize custom icon and markers from Firestore
  Future<void> _initializeMap() async {
    await loadCustomIcon();
    await loadMarkersFromFirestore();
  }

  // Load a custom icon for the markers
  Future<void> loadCustomIcon() async {
    final Uint8List markerIcon = await getBytesFromAssets('assets/thistleLOGO.png', 100);
    setState(() {
      customIcon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  // Convert an asset image to a Uint8List for use as a BitmapDescriptor
  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Load markers from Firestore and add them to the _markers list
  Future<void> loadMarkersFromFirestore() async {
    final markersSnapshot = await _firestore.collection('markers').get();
    for (var doc in markersSnapshot.docs) {
      final data = doc.data();
      final GeoPoint geoPoint = data['location'];
      final LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId(doc.id),
          position: position,
          icon: customIcon!,
          infoWindow: InfoWindow(title: data['title']),
        ),
      );
    }
    setState(() {});  // Update the UI with the new markers
  }

  // Add a marker to the map and Firestore based on a user tap
  Future<void> addMarker(LatLng position) async {
    String? title = await _showTitleDialog();
    if (title != null && title.isNotEmpty) {
      final newDocRef = await _firestore.collection('markers').add({
        'title': title,
        'location': GeoPoint(position.latitude, position.longitude),
      });
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(newDocRef.id),
            position: position,
            icon: customIcon!,
            infoWindow: InfoWindow(title: title),
          ),
        );
      });
    }
  }

  // Show a dialog to get the title of the new marker
  Future<String?> _showTitleDialog() async {
    String? title;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Marker'),
        content: TextField(
          onChanged: (value) => title = value,
          decoration: InputDecoration(hintText: 'Enter marker title'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () => Navigator.of(context).pop(title),
          ),
        ],
      ),
    );
    return title;
  }

  // Set the map to standard style
  void _setStandardMapStyle() {
    _controller.future.then((controller) {
      controller.setMapStyle(null); // Setting to null resets to the standard style
    });
  }

  // Set the map style based on the selected theme
  void _setMapStyle(String themeName) {
    _controller.future.then((controller) {
      if (themeName == 'standard') {
        controller.setMapStyle(null);
      } else {
        DefaultAssetBundle.of(context)
            .loadString('assets/thistleMapTheme/${themeName}_theme.json')
            .then((string) {
          controller.setMapStyle(string);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thistle Events Map', style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Color(0xFFC5C7FF),
        actions: [
          PopupMenuButton<String>(
            color: Color(0xFFD1D3FF),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'standard', child: Text('Standard')),
              PopupMenuItem(value: 'dark', child: Text('Dark')),
              PopupMenuItem(value: 'silver', child: Text('Silver')),
              PopupMenuItem(value: 'retro', child: Text('Retro')),
              PopupMenuItem(value: 'night', child: Text('Night')),
              PopupMenuItem(value: 'aubergine', child: Text('Aubergine')),
            ],
            onSelected: _setMapStyle,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<ApplicationState>(context, listen: false).onNavBarTap(0);
          },
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 15),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _setStandardMapStyle(); // Set the standard style when map is created
          },
          onTap: (LatLng position) => addMarker(position),
        ),
      ),
    );
  }
}