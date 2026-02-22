# Map Workflow Implementation Summary

## ✅ Completed

### Backend
1. **Shop Model Updated**
   - Added `locationSet: Boolean` field
   - Tracks if shop owner has set location

2. **Location API Enhanced**
   - `POST /api/location/shop/location` - Sets `locationSet = true`
   - `GET /api/location/shop/:shopId/status` - Check location status
   - Nearby shops API already working

### Shop Owner App
1. **Location Setup Screen** - Created ✅
2. **Profile Integration** - "Setup Shop Location" button added ✅

### User App
1. **Nearby Shops Map** - Created ✅
2. **Order Pickup Screen** - Created with directions ✅
3. **Home Screen Map Icon** - Added ✅

## 🔄 Pending Implementation

### 1. Force Location Setup on Login (Shop Owner)

**File:** `shop_owner_app/lib/screens/splash_screen.dart`

Add check after login:
```dart
// After shop loaded
if (shop != null && shop['locationSet'] != true) {
  // Redirect to location setup
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ShopLocationSetupScreen(mandatory: true),
    ),
  );
}
```

### 2. Block Product Access Without Location

**File:** `shop_owner_app/lib/screens/products/add_product_screen.dart`

Add check in initState:
```dart
final shop = Provider.of<ShopProvider>(context, listen: false).currentShop;
if (shop == null || shop['locationSet'] != true) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Location Required'),
      content: Text('Please set your shop location first'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopLocationSetupScreen(),
              ),
            );
          },
          child: Text('Setup Location'),
        ),
      ],
    ),
  );
  return;
}
```

### 3. Show Only Nearby Shops (User App)

**File:** `user_app/lib/providers/shop_provider.dart`

Update loadShops method:
```dart
Future<void> loadNearbyShops() async {
  // Get user location
  Position position = await Geolocator.getCurrentPosition();
  
  // Fetch nearby shops from API
  final shops = await _locationService.getDeliverableShops(
    latitude: position.latitude,
    longitude: position.longitude,
  );
  
  _shops = shops;
  notifyListeners();
}
```

### 4. Show Distance on Shop Cards

**File:** `user_app/lib/screens/shops/shops_screen.dart`

Add distance display:
```dart
if (shop['distance'] != null)
  Row(
    children: [
      Icon(Icons.location_on, size: 16, color: Colors.green),
      SizedBox(width: 4),
      Text(
        '${shop['distance'].toStringAsFixed(1)} km away',
        style: TextStyle(color: Colors.green, fontSize: 12),
      ),
    ],
  ),
```

### 5. Add "Get Directions" in Order Details

**File:** `user_app/lib/screens/orders/order_details_screen.dart`

When order status is "Accepted" or "Ready for Pickup":
```dart
if (order['status'] == 'Accepted' || order['status'] == 'Ready for Pickup')
  ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPickupScreen(
            shopName: order['shopName'],
            shopAddress: order['shopAddress'],
            shopLatitude: order['shopLocation']['coordinates'][1],
            shopLongitude: order['shopLocation']['coordinates'][0],
          ),
        ),
      );
    },
    icon: Icon(Icons.directions),
    label: Text('Get Directions'),
  ),
```

## Quick Implementation Guide

### Step 1: Update Backend (Already Done ✅)
```bash
cd backend
git add .
git commit -m "Add locationSet field and location status API"
git push origin main
```

### Step 2: Shop Owner App - Force Location Setup

Create: `shop_owner_app/lib/screens/location/location_check_screen.dart`
```dart
// Screen that checks location and redirects
class LocationCheckScreen extends StatefulWidget {
  @override
  State<LocationCheckScreen> createState() => _LocationCheckScreenState();
}

class _LocationCheckScreenState extends State<LocationCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    final shop = Provider.of<ShopProvider>(context, listen: false).currentShop;
    
    if (shop == null || shop['locationSet'] != true) {
      // Force location setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShopLocationSetupScreen(mandatory: true),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

### Step 3: User App - Fetch Nearby Shops

Update: `user_app/lib/screens/home/home_screen.dart`
```dart
Future<void> _loadNearbyShops() async {
  try {
    Position position = await Geolocator.getCurrentPosition();
    
    final locationService = LocationService();
    final shops = await locationService.getDeliverableShops(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    
    // Update shop provider
    Provider.of<ShopProvider>(context, listen: false).setShops(shops);
  } catch (e) {
    print('Error loading nearby shops: $e');
    // Fallback: load all shops
    Provider.of<ShopProvider>(context, listen: false).loadShops();
  }
}
```

### Step 4: Show Distance

Update shop card widget to display distance from shop data.

### Step 5: Order Navigation

Update order details to show "Get Directions" button when order is accepted.

## Testing Flow

### Shop Owner
1. Login → Check location
2. If not set → Force location setup
3. Set location → Can add products
4. Accept order → User gets notification

### User
1. Open app → Get location
2. See nearby shops with distance
3. Place order
4. Order accepted → "Get Directions" appears
5. Tap → Opens map with navigation

## Files to Modify

### Backend (Done ✅)
- `models/Shop.js`
- `routes/location.js`

### Shop Owner App (Partial)
- `screens/splash_screen.dart` - Add location check
- `screens/products/add_product_screen.dart` - Block without location
- `screens/location/shop_location_setup_screen.dart` - Already created ✅

### User App (Partial)
- `screens/home/home_screen.dart` - Fetch nearby shops
- `screens/shops/shops_screen.dart` - Show distance
- `screens/orders/order_details_screen.dart` - Add directions button
- `screens/orders/order_pickup_screen.dart` - Already created ✅

## Current Status

**Working:**
- ✅ Location setup screen (Shop Owner)
- ✅ Map view (User)
- ✅ Order pickup with directions (User)
- ✅ Backend location APIs

**Needs Integration:**
- ⏳ Force location setup on login
- ⏳ Block product access without location
- ⏳ Filter shops by distance
- ⏳ Show distance on shop cards
- ⏳ Add directions button in order details

## Next Steps

1. Implement force location check in splash screen
2. Add location validation before product creation
3. Update shop listing to show only nearby shops
4. Add distance display on shop cards
5. Integrate directions button in order flow
6. Test complete workflow
7. Rebuild APKs

Would you like me to implement these remaining features now?
