# Location & Maps Setup Guide

## Features Implemented

### 1. Shop Location Setup (Shop Owner App)
- Google Maps integration for location selection
- Current location detection using GPS
- Manual location selection by tapping on map
- Delivery radius configuration (1-50 KM)
- Location permission handling
- Save location to backend with coordinates

### 2. Order Pickup Screen (User App)
- Display shop location on Google Maps
- Show distance between user and shop
- Real-time user location tracking
- "Get Directions" button to open Google Maps
- Shop details display (name, address)

### 3. Backend Geo Queries
- MongoDB 2dsphere index for geospatial queries
- Find nearby shops within radius
- Sort shops by distance
- Filter shops within delivery radius
- Calculate distance in kilometers

## Setup Instructions

### 1. Install Dependencies

#### Shop Owner App
```bash
cd shop_owner_app
flutter pub get
```

#### User App
```bash
cd user_app
flutter pub get
```

### 2. Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
4. Create API Key in Credentials
5. Restrict API key (optional but recommended)

### 3. Configure Android

#### Shop Owner App
Edit `shop_owner_app/android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

#### User App
Edit `user_app/android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

### 4. Configure iOS

iOS configuration is already set in Info.plist files. No additional changes needed.

### 5. Setup MongoDB Geo Index

Run the index creation script:
```bash
cd backend
node create_geo_index.js
```

This will:
- Create 2dsphere index on location field
- Update existing shops with default location

### 6. Start Backend Server

```bash
cd backend
npm start
```

## Usage

### Shop Owner - Setup Location

1. After Google Sign-In (first time)
2. Navigate to Shop Location Setup screen
3. Grant location permission
4. Current location will be auto-selected
5. Or tap on map to select different location
6. Enter delivery radius (in KM)
7. Click "Save Location"

```dart
// Navigate to location setup
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ShopLocationSetupScreen(),
  ),
);
```

### User - View Pickup Location

When order status is "Ready for Pickup":

```dart
// Navigate to pickup screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OrderPickupScreen(
      shopName: 'Shop Name',
      shopAddress: 'Shop Address',
      shopLatitude: 28.6139,
      shopLongitude: 77.2090,
    ),
  ),
);
```

## API Endpoints

### Save Shop Location
```
POST /api/location/shop/location
Body: {
  "shopId": "shop_id",
  "latitude": 28.6139,
  "longitude": 77.2090,
  "deliveryRadius": 5
}
```

### Get Nearby Shops
```
POST /api/location/shops/nearby
Body: {
  "latitude": 28.6139,
  "longitude": 77.2090,
  "maxDistance": 10
}
```

### Get Deliverable Shops
```
POST /api/location/shops/deliverable
Body: {
  "latitude": 28.6139,
  "longitude": 77.2090
}
```

### Get Shops Within Radius
```
GET /api/location/shops/radius?latitude=28.6139&longitude=77.2090&radius=5
```

## Database Schema

```javascript
location: {
  type: {
    type: String,
    enum: ['Point'],
    default: 'Point'
  },
  coordinates: {
    type: [Number],  // [longitude, latitude]
    default: [0, 0]
  }
},
deliveryRadius: {
  type: Number,
  default: 5,
  min: 0,
  max: 50
}
```

## Permissions

### Android
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- INTERNET

### iOS
- NSLocationWhenInUseUsageDescription
- NSLocationAlwaysUsageDescription
- NSLocationAlwaysAndWhenInUseUsageDescription

## Testing

### Test Location Service
```dart
final locationService = LocationService();

// Get nearby shops
final shops = await locationService.getNearbyShops(
  latitude: 28.6139,
  longitude: 77.2090,
  maxDistance: 10,
);

// Get deliverable shops
final deliverable = await locationService.getDeliverableShops(
  latitude: 28.6139,
  longitude: 77.2090,
);
```

## Troubleshooting

### Maps not showing
- Check API key is correct
- Verify APIs are enabled in Google Cloud Console
- Check internet connection
- Verify AndroidManifest.xml has correct API key

### Location permission denied
- Check AndroidManifest.xml has location permissions
- Check Info.plist has location usage descriptions
- Request permission at runtime

### Geo queries not working
- Run `node create_geo_index.js` to create index
- Verify MongoDB connection
- Check coordinates format: [longitude, latitude]

## Files Created

### Shop Owner App
- `lib/screens/location/shop_location_setup_screen.dart`
- `lib/services/shop_api_service.dart` (updated)
- `lib/providers/shop_provider.dart` (updated)
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

### User App
- `lib/screens/orders/order_pickup_screen.dart`
- `lib/services/location_service.dart`
- `lib/services/api_service.dart`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

### Backend
- `routes/location.js`
- `models/Shop.js` (updated)
- `server.js` (updated)
- `create_geo_index.js`
