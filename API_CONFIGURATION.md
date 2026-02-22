# API Configuration

## Current Setup

Both Flutter apps are configured to use the production backend on Render.

### Backend URL
```
https://instantpick-backend.onrender.com/api
```

### User App
**File:** `user_app/lib/services/api_service.dart`
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

### Shop Owner App
**File:** `shop_owner_app/lib/services/api_service.dart`
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

## API Endpoints

### Health Check
```
GET https://instantpick-backend.onrender.com/api/health
```

### Shops
```
GET    /api/shops              - Get all shops
GET    /api/shops/:id          - Get shop by ID
POST   /api/shops              - Create shop
PUT    /api/shops/:id          - Update shop
DELETE /api/shops/:id          - Delete shop
```

### Products
```
GET    /api/products           - Get all products
GET    /api/products/:id       - Get product by ID
POST   /api/products           - Create product
PUT    /api/products/:id       - Update product
DELETE /api/products/:id       - Delete product
```

### Orders
```
GET    /api/orders             - Get all orders
GET    /api/orders/:id         - Get order by ID
POST   /api/orders             - Create order
PUT    /api/orders/:id         - Update order
```

### Location
```
POST   /api/location/shop/location        - Save shop location
POST   /api/location/shops/nearby         - Get nearby shops
POST   /api/location/shops/deliverable    - Get deliverable shops
GET    /api/location/shops/radius         - Get shops within radius
```

### Upload
```
POST   /api/upload             - Upload image (ImageKit)
POST   /api/upload-base64      - Upload image (Base64 fallback)
```

## Testing API

### Using cURL
```bash
# Health check
curl https://instantpick-backend.onrender.com/api/health

# Get shops
curl https://instantpick-backend.onrender.com/api/shops

# Get products
curl https://instantpick-backend.onrender.com/api/products
```

### Using Browser
Open in browser:
```
https://instantpick-backend.onrender.com/api/health
```

## Timeout Settings

Both apps use 60-second timeout for API requests to handle Render's cold start (free tier).

```dart
.timeout(const Duration(seconds: 60))
```

## Error Handling

### Network Errors
- No internet connection
- Request timeout
- Server errors (500)
- Not found (404)

### User-Friendly Messages
- "No internet connection. Please check your network."
- "Request timeout. Please check your internet connection."
- "Failed to load shops"
- "Failed to load products"

## Changing Backend URL

If you need to change the backend URL (e.g., for local testing):

### User App
Edit `user_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'YOUR_NEW_URL/api';
```

### Shop Owner App
Edit `shop_owner_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'YOUR_NEW_URL/api';
```

### Rebuild APKs
```bash
# User App
cd user_app
flutter build apk --release --no-tree-shake-icons

# Shop Owner App
cd shop_owner_app
flutter build apk --release --no-tree-shake-icons
```

## Local Testing URLs

If running backend locally:

### Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### Real Android Device (same WiFi)
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api';
```

Replace `YOUR_COMPUTER_IP` with your computer's local IP address (e.g., `192.168.1.100`).

## Production Checklist

- [x] Backend deployed on Render
- [x] MongoDB Atlas configured
- [x] User App using Render URL
- [x] Shop Owner App using Render URL
- [x] 60-second timeout for cold starts
- [x] Error handling implemented
- [x] Logging enabled for debugging

## Monitoring

### Check Backend Status
```bash
curl https://instantpick-backend.onrender.com/api/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Marketplace API is running",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### Check Render Dashboard
- https://dashboard.render.com
- View logs
- Check service status
- Monitor requests

## Troubleshooting

### "Failed to load shops"
1. Check internet connection
2. Verify backend is running on Render
3. Check Render logs for errors
4. Test API endpoint in browser

### "Request timeout"
1. Render free tier has cold starts (30-60 seconds)
2. Wait and retry
3. Check Render service status

### "No products available"
1. Backend is running but database is empty
2. Add products using Shop Owner app
3. Check MongoDB Atlas has data

## Next Steps

1. Deploy backend to Render (if not done)
2. Test API endpoints
3. Install APKs on devices
4. Test full flow:
   - Shop owner creates shop
   - Shop owner adds products
   - User views shops
   - User views products
   - User places order
