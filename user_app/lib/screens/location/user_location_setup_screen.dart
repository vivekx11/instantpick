import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/api_service.dart';

class UserLocationSetupScreen extends StatefulWidget {
  final bool mandatory;
  final bool isFirstTime;
  
  const UserLocationSetupScreen({
    Key? key, 
    this.mandatory = false,
    this.isFirstTime = false,
  }) : super(key: key);

  @override
  State<UserLocationSetupScreen> createState() => _UserLocationSetupScreenState();
}

class _UserLocationSetupScreenState extends State<UserLocationSetupScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  bool _isLoading = false;
  final TextEditingController _addressController = TextEditingController();

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
      _showSnackBar('Please select your location');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _showSnackBar('Please enter your address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      
      // If userId not found in prefs, try to get from Google auth
      if (userId == null || userId.isEmpty) {
        final googleUser = await GoogleSignIn().signInSilently();
        if (googleUser != null) {
          userId = googleUser.id;
          await prefs.setString('userId', userId);
        }
      }

      if (userId == null || userId.isEmpty) {
        throw Exception('User not logged in. Please login again.');
      }

      final apiService = ApiService();
      await apiService.post('/users/$userId/location', {
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'address': _addressController.text.trim(),
      });

      // Save locally
      await prefs.setDouble('userLatitude', _selectedLocation!.latitude);
      await prefs.setDouble('userLongitude', _selectedLocation!.longitude);
      await prefs.setString('userAddress', _addressController.text.trim());
      await prefs.setBool('userLocationSet', true);

      if (mounted) {
        _showSnackBar('Location saved successfully');
        if (widget.mandatory || widget.isFirstTime) {
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
    final bool canDismiss = !widget.mandatory && !widget.isFirstTime;
    showDialog(
      context: context,
      barrierDismissible: canDismiss,
      builder: (context) => WillPopScope(
        onWillPop: () async => canDismiss,
        child: AlertDialog(
          title: const Text('Location Permission'),
          content: const Text('This app needs location permission to show nearby shops and deliver to your location.'),
          actions: [
            if (canDismiss)
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
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = !widget.mandatory && !widget.isFirstTime;
    return WillPopScope(
      onWillPop: () async => canGoBack,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setup Your Location'),
          elevation: 0,
          automaticallyImplyLeading: canGoBack,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (widget.mandatory || widget.isFirstTime)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange.shade100,
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please set your delivery location to continue',
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
                              userAgentPackageName: 'com.example.user_app',
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
                                          'Your Location',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
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
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                          hintText: 'Enter your complete address',
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
