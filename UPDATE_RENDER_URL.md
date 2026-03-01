# 🔧 Update Render URL - Complete Guide

## Your Render Backend URL

Aapko apna actual Render backend URL chahiye. Ye kaise milega:

### Step 1: Find Your Render Backend URL

1. Go to: https://dashboard.render.com
2. Click on your backend service
3. Top pe aapko URL dikhega, example:
   ```
   https://marketplace-api-xyz.onrender.com
   ```

Copy this URL!

---

## Files to Update

### 1. Admin App API Constants ⭐ (Most Important)

**File:** `admin_app/lib/core/constants/api_constants.dart`

**Current:**
```dart
static const String baseUrl = 'https://your-backend-name.onrender.com/api';
```

**Update to:**
```dart
static const String baseUrl = 'https://marketplace-api-xyz.onrender.com/api';
```

Replace `marketplace-api-xyz` with your actual Render backend name.

**Example URLs:**
```dart
// If your Render URL is: https://instantpick-backend.onrender.com
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';

// If your Render URL is: https://marketplace-api.onrender.com
static const String baseUrl = 'https://marketplace-api.onrender.com/api';
```

---

### 2. Test Script (Optional)

**File:** `test_admin_api.js`

**Current:**
```javascript
const BASE_URL = 'https://your-backend-name.onrender.com';
```

**Update to:**
```javascript
const BASE_URL = 'https://marketplace-api-xyz.onrender.com';
```

**Or use the production test script:**
```bash
node test_admin_production.js https://marketplace-api-xyz.onrender.com
```

---

## Quick Update Commands

### Option 1: Manual Update

1. Open `admin_app/lib/core/constants/api_constants.dart`
2. Find line with `baseUrl`
3. Replace with your Render URL
4. Save file

### Option 2: Using Find & Replace

**VS Code:**
1. Press `Ctrl+Shift+H` (Windows) or `Cmd+Shift+H` (Mac)
2. Find: `your-backend-name.onrender.com`
3. Replace: `marketplace-api-xyz.onrender.com`
4. Replace All

---

## Verify Your URL

### Test Backend Health

```bash
curl https://YOUR-RENDER-URL.onrender.com/api/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Marketplace API is running"
}
```

### Test Admin API

```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://YOUR-RENDER-URL.onrender.com/api/admin/stats
```

Expected response:
```json
{
  "success": true,
  "stats": { ... }
}
```

---

## Common Render URL Patterns

Your Render URL will look like one of these:

```
https://marketplace-backend.onrender.com
https://instantpick-api.onrender.com
https://my-marketplace.onrender.com
https://backend-xyz123.onrender.com
```

**Important:**
- Always use `https://` (not `http://`)
- No trailing slash
- Add `/api` in the code (already done)

---

## After Updating URL

### 1. Rebuild Admin App

```bash
cd admin_app
flutter clean
flutter pub get
flutter build web --release
```

### 2. Test Locally First (Optional)

```bash
# Start a local server
cd admin_app/build/web
python -m http.server 8000

# Open browser
# http://localhost:8000
```

### 3. Deploy

```bash
firebase deploy --only hosting
```

---

## Troubleshooting

### Issue: Can't find Render URL

**Solution:**
1. Login to Render Dashboard
2. Click your backend service
3. URL is at the top of the page
4. Copy the full URL

### Issue: URL not working

**Check:**
- Backend is deployed and running
- URL starts with `https://`
- URL ends with `.onrender.com`
- No typos in URL

### Issue: CORS error after updating

**Solution:**
1. Add `ADMIN_APP_URL` in Render environment
2. Redeploy backend
3. Clear browser cache

---

## Complete Example

Let's say your Render backend URL is:
```
https://instantpick-backend.onrender.com
```

### Update api_constants.dart:

```dart
class ApiConstants {
  // Production Render URL
  static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
  
  // Admin endpoints
  static const String adminStats = '/admin/stats';
  static const String adminUsers = '/admin/users';
  static const String adminShops = '/admin/shops';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminLogs = '/admin/logs';
}
```

### Test it:

```bash
# Test health
curl https://instantpick-backend.onrender.com/api/health

# Test admin API
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://instantpick-backend.onrender.com/api/admin/stats

# Test with production script
node test_admin_production.js https://instantpick-backend.onrender.com
```

### Build & Deploy:

```bash
cd admin_app
flutter build web --release
firebase deploy --only hosting
```

---

## Checklist

- [ ] Found Render backend URL from dashboard
- [ ] Updated `api_constants.dart` with correct URL
- [ ] Tested backend health endpoint
- [ ] Tested admin API endpoint
- [ ] Rebuilt admin app
- [ ] Deployed admin app
- [ ] Tested login in deployed app

---

## Quick Test Script

Use the production test script:

```bash
node test_admin_production.js https://YOUR-RENDER-URL.onrender.com
```

This will test all admin endpoints automatically!

---

## 🎉 Done!

Once URL is updated and app is deployed:

1. Open your admin app URL
2. Login with: `V!v3k@29#20$Secure`
3. Dashboard should load with data from Render backend

---

**Need your actual Render URL?**
👉 Go to: https://dashboard.render.com
👉 Click your backend service
👉 Copy the URL from the top

**Then update `api_constants.dart` and rebuild!** 🚀
