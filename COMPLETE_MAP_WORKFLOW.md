# Complete Map Workflow Implementation

## Shop Owner Flow

### 1. Sign In → Mandatory Location Setup
- Shop owner signs in (Google/Phone)
- If shop exists but NO location set → Force redirect to Location Setup
- Cannot access Products/Orders until location is set
- Location setup includes:
  - Current location or manual selection
  - Delivery radius (mandatory)
  - Save to backend

### 2. Product Management (After Location Setup)
- Can add/edit products only after location is set
- Products are linked to shop with location

## User Flow

### 1. Browse Nearby Shops
- User opens app
- Fetches user's current location
- Shows only shops within delivery radius
- Displays distance (e.g., "2 km away")
- Sorted by nearest first

### 2. View Shop on Map
- Map icon shows all nearby shops
- Each shop marker shows:
  - Shop name
  - Distance from user
  - Delivery radius indicator

### 3. Place Order
- User selects shop → views products
- Places order
- Order includes user's current location

### 4. Order Accepted → Navigation
- Shop owner accepts order
- User gets notification
- "Get Directions" button appears
- Opens map with:
  - User's location (blue marker)
  - Shop location (red marker)
  - Route/directions
  - Distance and ETA

## Implementation Steps

### Backend Changes
1. Add `locationSet` flag to Shop model
2. Validate location before product creation
3. Filter shops by user location and delivery radius
4. Add distance calculation to shop queries

### Shop Owner App Changes
1. Check location on login
2. Force location setup if not set
3. Block product/order access until location set
4. Show location status in profile

### User App Changes
1. Get user location on app start
2. Fetch only nearby shops (within delivery radius)
3. Show distance on shop cards
4. Add "Get Directions" in order details (when accepted)
5. Filter shops by distance

## Database Schema Updates

```javascript
// Shop Model
{
  location: {
    type: { type: String, enum: ['Point'] },
    coordinates: [Number] // [longitude, latitude]
  },
  deliveryRadius: Number, // in KM
  locationSet: Boolean, // NEW: Track if location is configured
  address: String
}

// Order Model
{
  userLocation: {
    type: { type: String, enum: ['Point'] },
    coordinates: [Number]
  },
  shopLocation: {
    type: { type: String, enum: ['Point'] },
    coordinates: [Number]
  },
  distance: Number // calculated distance
}
```

## API Endpoints

### Shop Location
- `POST /api/location/shop/location` - Set shop location (mandatory)
- `GET /api/location/shop/:shopId/status` - Check if location is set

### Nearby Shops
- `POST /api/location/shops/nearby` - Get shops within user's range
- Response includes distance for each shop

### Order Navigation
- `GET /api/orders/:orderId/navigation` - Get navigation data
- Returns user location, shop location, distance

## UI Flow

### Shop Owner App
```
Login → Check Location Status
  ├─ Location Not Set → Force Location Setup Screen
  │   └─ Setup Complete → Home Screen
  └─ Location Set → Home Screen
      ├─ Products (Enabled)
      ├─ Orders (Enabled)
      └─ Profile → Update Location
```

### User App
```
Home Screen
  ├─ Get User Location
  ├─ Fetch Nearby Shops (within delivery radius)
  ├─ Show Distance on Each Shop Card
  └─ Map Icon → View All Shops on Map

Order Flow
  ├─ Place Order (includes user location)
  ├─ Wait for Acceptance
  └─ Order Accepted
      └─ "Get Directions" Button
          └─ Opens Map with Navigation
```

## Key Features

### Distance Calculation
- Haversine formula for accurate distance
- Real-time calculation
- Displayed in KM

### Delivery Radius Validation
- Shop sets delivery radius (e.g., 5 KM)
- Only users within radius can see shop
- Prevents orders from too far

### Navigation
- User location → Shop location
- Opens external Google Maps
- Shows route and ETA

## Error Handling

### Shop Owner
- Location permission denied → Show instructions
- GPS disabled → Prompt to enable
- Location not set → Block product access

### User
- Location permission denied → Show all shops (no filtering)
- GPS disabled → Use last known location
- No nearby shops → Show message

## Testing Checklist

- [ ] Shop owner forced to set location on first login
- [ ] Cannot add products without location
- [ ] User sees only nearby shops
- [ ] Distance displayed correctly
- [ ] Map shows all nearby shops
- [ ] Order includes user location
- [ ] "Get Directions" works after order acceptance
- [ ] Navigation opens Google Maps
- [ ] Distance updates in real-time
