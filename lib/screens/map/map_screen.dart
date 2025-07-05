import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _shineSpotLocation = LatLng(13.8191, 121.1711);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('shineSpotStudio'),
      position: _shineSpotLocation,
      infoWindow: InfoWindow(
        title: 'Shine Spot Studio',
        snippet: '2nd Floor, CGN Building, Barangay San Pedro, Santo Tomas, Batangas',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _shineSpotLocation,
              zoom: 14.0,
            ),
            markers: _markers,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 12, right: 12), // Adjusted padding
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Shine Spot Studio", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 4),
                      const Text(
                        "2nd Floor, CGN Building, Barangay San Pedro, Santo Tomas, Batangas, Philippines.\nMonday to Sunday 10am to 7pm",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 8),
                          Text("0991 690 5443", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 8),
                          Text("shinespotstudio@gmail.com", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}