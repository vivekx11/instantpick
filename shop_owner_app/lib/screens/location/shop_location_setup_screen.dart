import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/shop_provider.dart';
import '../../services/shop_api_service.dart';

class ShopLocationSetupScreen extends StatefulWidget {
  final bool isFirstTime;
  
  const ShopLocationSetupScreen({
    Key? key,
    this.isFirstTime = false,
  }) : super(key: key);

  @override
  State<ShopLocationSetupScreen> createState() => _ShopLocationSetupScreenState();
}

class _ShopLocationSetupScreenState extends State<ShopLocationSetupScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  bool _isLoading = false;
  final TextEditingController _radiusController = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Please enable location services');
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Move map after a short delay to ensure MapController is initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _selectedLocation != null) {
          try {
            _mapController.move(_selectedLocation!, 15.0);
          } catch (e) {
            print('Error moving map: $e');
          }
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error getting location: $e');
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation == null) {
      _showSnackBar('Please select a location');
      return;
    }

    final radius = double.tryParse(_radiusController.text);
    if (radius == null || radius <= 0 || radius > 50) {
      _showSnackBar('Please enter valid delivery radius (1-50 KM)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      
      // Get shopId from provider or SharedPreferences
      String? shopId = shopProvider.shopId;
      
      if (shopId == null || shopId.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        shopId = prefs.getString('shopId');
      }
      
      if (shopId == null || shopId.isEmpty) {
        throw Exception('Shop not found. Please login again.');
      }
      
      // Update location using API service directly
      final shopApiService = ShopApiService();
      await shopApiService.updateShopLocation(
        shopId,
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
        radius,
      );
      
      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('shopLocationSet', true);

      if (mounted) {
        _showSnackBar('Location saved successfully');
        if (widget.isFirstTime) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      _showSnackBar('Error saving location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: !widget.isFirstTime,
      builder: (context) => WillPopScope(
        onWillPop: () async => !widget.isFirstTime,
        child: AlertDialog(
          title: const Text('Location Permission'),
          content: const Text('This app needs location permission to set your shop location.'),
          actions: [
            if (!widget.isFirstTime)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _requestLocationPermission();
              },
              child: const Text('Grant'),
            ),
          ],
        ),
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
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.isFirstTime,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setup Shop Location'),
          elevation: 0,
          automaticallyImplyLeading: !widget.isFirstTime,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (widget.isFirstTime)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange.shade100,
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please set your shop location before adding products',
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
              Expanded(
                child: _selectedLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation!,
                          initialZoom: 15.0,
                          minZoom: 5.0,
                          maxZoom: 18.0,
                          onTap: _onMapTap,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.shop_owner_app',
                            maxZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _selectedLocation!,
                                width: 80,
                                height: 80,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                      child: const Text(
                                        'Shop Location',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedLocation != null) ...[
                      const Text(
                        'Selected Location:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: _radiusController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Radius (KM)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.delivery_dining),
                        hintText: 'Enter radius in kilometers',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _getCurrentLocation,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Current Location'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _saveLocation,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Location'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
