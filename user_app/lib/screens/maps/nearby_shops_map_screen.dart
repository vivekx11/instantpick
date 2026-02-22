import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';

class NearbyShopsMapScreen extends StatefulWidget {
  const NearbyShopsMapScreen({Key? key}) : super(key: key);

  @override
  State<NearbyShopsMapScreen> createState() => _NearbyShopsMapScreenState();
}

class _NearbyShopsMapScreenState extends State<NearbyShopsMapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  
  Position? _userPosition;
  List<Map<String, dynamic>> _shops = [];
  bool _isLoading = true;
  Map<String, dynamic>? _selectedShop;

  @override
  void initState() {
    super.initState();
    _loadNearbyShops();
  }

  Future<void> _loadNearbyShops() async {
    setState(() => _isLoading = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Please enable location services');
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _showSnackBar('Location permission required');
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _userPosition = position;

      final shops = await _locationService.getDeliverableShops(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _shops = shops;
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onMarkerTap(Map<String, dynamic> shop) {
    setState(() => _selectedShop = shop);
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildShopDetails(shop),
    );
  }

  Widget _buildShopDetails(Map<String, dynamic> shop) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shop['name'] ?? 'Shop',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  shop['address'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.directions_car, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                'Distance: ${shop['distance']?.toStringAsFixed(2) ?? '0'} km',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/shop-products', arguments: shop);
              },
              child: const Text('View Products'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbyShops,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userPosition == null
              ? const Center(child: Text('Unable to get location'))
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                    initialZoom: 13.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.user_app',
                      maxZoom: 19,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 3),
                            ),
                            child: const Icon(Icons.my_location, color: Colors.blue, size: 20),
                          ),
                        ),
                        ..._shops.map((shop) {
                          final location = shop['location'];
                          if (location == null || location['coordinates'] == null) {
                            return null;
                          }
                          final coords = location['coordinates'] as List;
                          return Marker(
                            point: LatLng(coords[1], coords[0]),
                            width: 80,
                            height: 80,
                            child: GestureDetector(
                              onTap: () => _onMarkerTap(shop),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      shop['name'] ?? 'Shop',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.store, color: Colors.red, size: 30),
                                ],
                              ),
                            ),
                          );
                        }).whereType<Marker>(),
                      ],
                    ),
                  ],
                ),
    );
  }
}
