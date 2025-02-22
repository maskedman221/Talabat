import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:talabat/core/cubit/profilecubit.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWithGeolocator extends StatefulWidget {
  
  @override
  _MapWithGeolocatorState createState() => _MapWithGeolocatorState();
}

class _MapWithGeolocatorState extends State<MapWithGeolocator> {
  final Location location = Location(); // Instance of your Location class
   late LatLng _currentLocation; // To store the user's current location
  final profileCubit=getIt<ProfileCubit>();
   
  @override
  void initState() {
    super.initState();
    _getLocation(); // Get location when the widget initializes
  }

  Future<void> _getLocation() async {
    try { // Use your Location class
      setState(() {
        _currentLocation = LatLng(profileCubit.state.user!.user.latitude, profileCubit.state.user!.user.longitude);
      });
    } catch (e) {
      // Handle location errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        
       
       
      ),
      body:FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(profileCubit.state.user!.user.latitude, profileCubit.state.user!.user.longitude), // Center the map over London
      initialZoom: 30,
    ),
    children: [
      TileLayer( // Display map tiles from any source
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
        userAgentPackageName: 'com.example.app',
        // And many more recommended properties!
      ),
      MarkerLayer(markers: [Marker(point: LatLng(profileCubit.state.user!.user.latitude, profileCubit.state.user!.user.longitude), child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),)]),
      RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
          ),
          // Also add images...
        ],
      ),
    ],
  ),
  );
}
}
