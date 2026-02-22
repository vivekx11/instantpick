# User Location Feature

## ✅ Implemented

### Backend
1. **User Model Updated**
   - Added `location` field (Point with coordinates)
   - Added `address` field (String)
   - Added `locationSet` field (Boolean)
   - Added 2dsphere index for geo queries

2. **User Location APIs**
   - `POST /api/users/:userId/location` - Save user location
   - `GET /api/users/:userId/location/status` - Check location status

### User App
1. **User Location Setup Screen** - Created ✅
   - Map with OpenStreetMap
   - Current location detection
   - Manual location selection (tap on map)
   - Address input field
   - Save to backend + local storage

## How It Works

### User Flow
1. User signs in
2. If location not set → Redirect to Location Setup (mandatory)
3. User selects location on map
4. Enters delivery address
5. Saves location
6. Can browse nearby shops

### Location Storage
- **Backend**: MongoDB with coordinates
- **Local**: SharedPreferences
  - `userLatitude`
  - `userLongitude`
  - `userAddress`
  - `userLocationSet`

### Nearby Shops Logic
```dart
// Get user's saved location
final prefs = await SharedPreferences.getInstance();
final lat = prefs.getDouble('userLatitude');
final lng = prefs.getDouble('userLongitude');

// Fetch nearby shops
final shops = await locationService.getDeliverableShops(
  latitude: lat,
  longitude: lng,
);
```

## Integration Points

### 1. Add to Profile Screen
```dart
ListTile(
  leading: Icon(Icons.location_on),
  title: Text('My Location'),
  subtitle: Text(userAddress ?? 'Not set'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserLocationSetupScreen(),
      ),
    );
  },
)
```

### 2. Check on App Start (Splash Screen)
```dart
final prefs = await SharedPreferences.getInstance();
final locationSet = prefs.getBool('userLocationSet') ?? false;

if (!locationSet) {
  // Redirect to location setup
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => UserLocationSetupScreen(mandatory: true),
    ),
  );
} else {
  // Go to home
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ),
  );
}
```

### 3. Filter Shops by User Location
```dart
// In home screen or shops screen
Future<void> _loadNearbyShops() async {
  final prefs = await SharedPreferences.getInstance();
  final lat = prefs.getDouble('userLatitude');
  final lng = prefs.getDouble('userLongitude');
  
  if (lat == null || lng == null) {
    // Location not set, load all shops
    await shopProvider.loadShops();
    return;
  }
  
  // Load nearby shops only
  final locationService = LocationService();
  final shops = await locationService.getDeliverableShops(
    latitude: lat,
    longitude: lng,
  );
  
  shopProvider.setShops(shops);
}
```

## API Usage

### Save User Location
```bash
POST /api/users/USER123456789/location
Content-Type: application/json

{
  "latitude": 19.204302,
  "longitude": 73.186292,
  "address": "123 Main Street, Mumbai, Maharashtra"
}
```

Response:
```json
{
  "success": true,
  "message": "Location updated successfully",
  "data": {
    "userId": "USER123456789",
    "location": {
      "type": "Point",
      "coordinates": [73.186292, 19.204302]
    },
    "address": "123 Main Street, Mumbai, Maharashtra",
    "locationSet": true
  }
}
```

### Check Location Status
```bash
GET /api/users/USER123456789/location/status
```

Response:
```json
{
  "success": true,
  "data": {
    "locationSet": true,
    "hasCoordinates": true,
    "address": "123 Main Street, Mumbai, Maharashtra"
  }
}
```

## Benefits

1. **Fixed Delivery Address**: User doesn't need to enter address every time
2. **Accurate Nearby Shops**: Shows only shops that can deliver to user
3. **Better UX**: One-time setup, then seamless browsing
4. **Distance Calculation**: Accurate distance from user's saved location
5. **Order Tracking**: Shop knows exact delivery location

## Next Steps

1. Add location setup button in profile screen
2. Check location on app start (splash screen)
3. Filter shops by user location in home screen
4. Show user's address in order confirmation
5. Allow user to update location anytime

## Files Created

### Backend
- `models/User.js` - Updated with location fields
- `routes/users.js` - Added location APIs

### User App
- `screens/location/user_location_setup_screen.dart` - Location setup UI

## Testing

1. Open user app
2. Go to profile (or will be forced on first login)
3. Tap "Setup Location" or "My Location"
4. Allow location permission
5. Select location on map
6. Enter address
7. Save
8. Check nearby shops are filtered by location
