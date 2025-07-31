import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Exact coordinates for Shine Spot Studio
  static const LatLng _studioLocation = LatLng(14.087961, 121.177384);
  
  late GoogleMapController _mapController;
  Position? _userLocation;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  bool _isLoading = true;
  bool _mapReady = false;
  
  // For custom marker icons
  BitmapDescriptor? _studioMarkerIcon;
  BitmapDescriptor? _userMarkerIcon;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      await _loadCustomMarkers();
      await _checkLocationPermission();
      setState(() => _isLoading = false);
      // Move marker addition to after map is created
    } catch (e) {
      _showError('Failed to initialize map: ${e.toString()}');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Add markers after map is created
    _addStudioMarker();
    setState(() => _mapReady = true);
  }

 Future<void> _loadCustomMarkers() async {
  try {
    // Load custom marker for the studio
    _studioMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/studio_marker.png',
    ).catchError((_) {
      // Fallback to a default marker if the asset fails to load
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    });

    // Use the default pin for the user's location
    _userMarkerIcon = BitmapDescriptor.defaultMarker;
    
  } catch (e) {
    // Fallback to default markers if any errors occur
    _studioMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _userMarkerIcon = BitmapDescriptor.defaultMarker;
  }
}

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _showError('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _showError('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _showError('Location permissions are permanently denied');
    }

    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = position;
        _updateMarkers();
      });
    } catch (e) {
      _showError('Could not get current location');
    }
  }

  void _updateMarkers() {
    _markers.clear();
    _circles.clear();

    // Add studio marker
    _markers.add(Marker(
      markerId: const MarkerId('studio'),
      position: _studioLocation,
      icon: _studioMarkerIcon ?? BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(
        title: 'Shine Spot Studio',
        snippet: '2nd Floor, CGN Building, Brgy. San Pedro',
      ),
    ));

    // Add user location marker if available
    if (_userLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId('user'),
        position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
        icon: _userMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));

      // Add a circle around the studio
      _circles.add(Circle(
        circleId: const CircleId('studioRadius'),
        center: _studioLocation,
        radius: 500, // 500 meters radius
        fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
        strokeColor: const Color.fromARGB(255, 0, 0, 0),
        strokeWidth: 1,
      ));
    }

    setState(() {});
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

 Future<void> _openGoogleMaps() async {
  final lat = _studioLocation.latitude;
  final lng = _studioLocation.longitude;
  final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    _showError('Could not open Google Maps');
  }
}

  void _animateToLocation(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 16.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  void _addStudioMarker() {
    try {
      if (!mounted) return;
      
      setState(() {
        _markers.add(Marker(
          markerId: const MarkerId('studio'),
          position: _studioLocation,
          icon: _studioMarkerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'Shine Spot Studio',
            snippet: '2nd Floor, CGN Building, Brgy. San Pedro',
          ),
        ));
      });
    } catch (e) {
      _showError('Failed to add marker: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_isLoading) GoogleMap(
            onMapCreated: _onMapCreated, // Updated this line
            initialCameraPosition: const CameraPosition(
              target: _studioLocation,
              zoom: 15.0,
            ),
            markers: _markers,
            circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            compassEnabled: true,
            buildingsEnabled: true,
          ) else const Center(
            child: CircularProgressIndicator(),
          ),

          // Location Controls
          Positioned(
            top: 50,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoomIn',
                  onPressed: () => _mapController.animateCamera(
                    CameraUpdate.zoomIn(),
                  ),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoomOut',
                  onPressed: () => _mapController.animateCamera(
                    CameraUpdate.zoomOut(),
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                if (_userLocation != null) FloatingActionButton.small(
                  heroTag: 'myLocation',
                  onPressed: () => _animateToLocation(
                    LatLng(_userLocation!.latitude, _userLocation!.longitude),
                  ),
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Studio Info Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.store, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "Shine Spot Studio",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "2nd Floor, CGN Building\nBarangay San Pedro, Santo Tomas\nBatangas, Philippines",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Operating Hours:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Monday to Sunday: 10:00 AM - 7:00 PM",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _animateToLocation(_studioLocation),
                              icon: const Icon(Icons.location_on),
                              label: const Text('Show Studio'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _openGoogleMaps,
                              icon: const Icon(Icons.directions),
                              label: const Text('Directions'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}