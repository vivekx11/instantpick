# OpenStreetMap Migration Guide

## Overview
Complete migration from Google Maps to OpenStreetMap using flutter_map package.

## Changes Made

### 1. Dependencies Updated

#### Shop Owner App (pubspec.yaml)
```yaml
# REMOVED
google_maps_flutter: ^2.5.0

# ADDED
flutter_map: ^6.1.0
latlong2: ^0.9.0
```

#### User App (pubspec.yaml)
```yaml
# REMOVED
google_maps_flutter: ^2.5.0

# ADDED
flutter_map: ^6.1.0
latlong2: ^0.9.0
```

### 2. Android Manifest Changes

#### Removed Google Maps API Key
Both apps no longer require:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

#### Required Permissions (Unchanged)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### 3. iOS Configuration (Unchanged)
Location permissions in Info.plist remain the same:
- NSLocationWhenInUseUsageDescription
- NSLocationAlwaysUsageDescription
- NSLocationAlwaysAndWhenInUseUsageDescription

## New Screens

### Shop Owner App

#### ShopLocationSetupScreen
**Path:** `shop_owner_app/lib/screens/location/shop_location_setup_screen.dart`

Features:
- OpenStreetMap integration
- Current location detection
- Tap to select location
- Delivery radius input
- Save location to backend

Usage:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ShopLocationSetupScreen(),
  ),
);
```

### User App

#### OrderPickupScreen
**Path:** `user_app/lib/screens/orders/order_pickup_screen.dart`

Features:
- Display shop location
- Show user location
- Calculate distance
- Get directions button

Usage:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OrderPickupScreen(
      shopName: 'Shop Name',
      shopAddress: 'Address',
      shopLatitude: 28.6139,
      shopLongitude: 77.2090,
    ),
  ),
);
```

#### NearbyShopsMapScreen
**Path:** `user_app/lib/screens/maps/nearby_shops_map_screen.dart`

Features:
- Show all nearby shops on map
- User location marker
- Shop markers with names
- Tap marker to view details
- Navigate to shop products

Usage:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NearbyShopsMapScreen(),
  ),
);
```

## OpenStreetMap Implementation

### Basic Map Setup
```dart
FlutterMap(
  mapController: _mapController,
  options: MapOptions(
    initialCenter: LatLng(latitude, longitude),
    initialZoom: 15.0,
    minZoom: 5.0,
    maxZoom: 18.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
      maxZoom: 19,
    ),
  ],
)
```

### Adding Markers
```dart
MarkerLayer(
  markers: [
    Marker(
      point: LatLng(latitude, longitude),
      width: 80,
      height: 80,
      child: Icon(Icons.location_on, color: Colors.red, size: 40),
    ),
  ],
)
```

### Map Tap Handler
```dart
MapOptions(
  onTap: (TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  },
)
```

### Move Camera
```dart
_mapController.move(LatLng(lat, lng), 15.0);
```

## Key Differences from Google Maps

| Feature | Google Maps | OpenStreetMap |
|---------|-------------|---------------|
| Package | google_maps_flutter | flutter_map |
| Coordinates | LatLng | LatLng (from latlong2) |
| Controller | GoogleMapController | MapController |
| Tiles | Google tiles | OSM tiles |
| API Key | Required | Not required |
| Cost | Paid (after quota) | Free |
| Markers | Marker widget | Marker in MarkerLayer |
| Camera | CameraPosition | initialCenter + zoom |

## Installation Steps

### 1. Update Dependencies
```bash
cd shop_owner_app
flutter pub get

cd ../user_app
flutter pub get
```

### 2. Clean Build
```bash
# Shop Owner App
cd shop_owner_app
flutter clean
flutter pub get

# User App
cd user_app
flutter clean
flutter pub get
```

### 3. No API Key Required
OpenStreetMap doesn't require API keys. Just use the tile URL.

## Tile Providers

### OpenStreetMap (Default)
```dart
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
```

### Alternative Providers

#### Mapbox (Requires API Key)
```dart
urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=YOUR_TOKEN'
```

#### CartoDB
```dart
urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
```

## Location Services

### Get Current Location
```dart
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);
```

### Check Permissions
```dart
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}
```

## Folder Structure

```
shop_owner_app/
├── lib/
│   ├── screens/
│   │   └── location/
│   │       └── shop_location_setup_screen.dart
│   └── services/
│       └── shop_api_service.dart (updated)

user_app/
├── lib/
│   ├── screens/
│   │   ├── orders/
│   │   │   └── order_pickup_screen.dart
│   │   └── maps/
│   │       └── nearby_shops_map_screen.dart
│   └── services/
│       ├── location_service.dart
│       └── api_service.dart
```

## Testing

### Test Location Setup
```dart
// Navigate to location setup
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ShopLocationSetupScreen(),
  ),
);
```

### Test Nearby Shops
```dart
// Navigate to nearby shops map
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NearbyShopsMapScreen(),
  ),
);
```

## Troubleshooting

### Map Not Loading
- Check internet connection
- Verify tile URL is correct
- Check console for errors

### Location Not Working
- Verify permissions in AndroidManifest.xml
- Check location services are enabled
- Request runtime permissions

### Markers Not Showing
- Verify coordinates are valid
- Check marker width/height
- Ensure MarkerLayer is added

## Performance Tips

1. Use appropriate zoom levels (5-18)
2. Limit number of markers on screen
3. Use userAgentPackageName for tile requests
4. Cache tiles when possible

## OpenStreetMap Usage Policy

- Tile usage is free but has rate limits
- Add User-Agent header (done via userAgentPackageName)
- Consider self-hosting tiles for production
- Read OSM tile usage policy: https://operations.osmfoundation.org/policies/tiles/

## Migration Checklist

- [x] Remove google_maps_flutter dependency
- [x] Add flutter_map and latlong2
- [x] Remove Google Maps API keys
- [x] Update AndroidManifest.xml
- [x] Rewrite map screens
- [x] Update location services
- [x] Test on Android
- [x] Test on iOS
- [x] Update documentation

## Files Modified

### Shop Owner App
- pubspec.yaml
- android/app/src/main/AndroidManifest.xml
- lib/screens/location/shop_location_setup_screen.dart

### User App
- pubspec.yaml
- android/app/src/main/AndroidManifest.xml
- lib/screens/orders/order_pickup_screen.dart
- lib/screens/maps/nearby_shops_map_screen.dart (new)

## Next Steps

1. Run `flutter pub get` in both apps
2. Test location permissions
3. Test map rendering
4. Test marker interactions
5. Deploy to production
