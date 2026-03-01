# 🚀 Render URL - Quick Update Guide

## Step 1: Get Your Render URL (1 minute)

1. Go to: https://dashboard.render.com
2. Login
3. Click your backend service
4. Copy URL from top (example: `https://marketplace-api-xyz.onrender.com`)

---

## Step 2: Update Admin App (2 minutes)

**File:** `admin_app/lib/core/constants/api_constants.dart`

**Find this line:**
```dart
static const String baseUrl = 'https://your-backend-name.onrender.com/api';
```

**Replace with your URL:**
```dart
static const String baseUrl = 'https://marketplace-api-xyz.onrender.com/api';
```

**Save file!**

---

## Step 3: Test Backend (1 minute)

```bash
# Replace with your actual URL
curl https://marketplace-api-xyz.onrender.com/api/health
```

Should return:
```json
{"status":"OK","message":"Marketplace API is running"}
```

✅ If you see this, backend is ready!

---

## Step 4: Test Admin API (1 minute)

```bash
# Replace with your actual URL
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://marketplace-api-xyz.onrender.com/api/admin/stats
```

Should return:
```json
{
  "success": true,
  "stats": {
    "totalUsers": 0,
    ...
  }
}
```

✅ If you see this, admin API is working!

---

## Step 5: Build & Deploy (5 minutes)

```bash
cd admin_app
flutter build web --release
firebase deploy --only hosting
```

---

## Quick Test Script

Use the production test script:

```bash
# Replace with your actual URL
node test_admin_production.js https://marketplace-api-xyz.onrender.com
```

This will test all endpoints automatically!

---

## Common URLs

Your Render URL will look like:

```
✅ https://marketplace-backend.onrender.com
✅ https://instantpick-api.onrender.com
✅ https://my-app-xyz.onrender.com

❌ http://marketplace-backend.onrender.com  (no http)
❌ https://marketplace-backend.onrender.com/  (no trailing slash)
```

---

## Troubleshooting

### Can't find Render URL?
👉 Dashboard → Your Service → URL at top

### Backend not responding?
👉 Check if backend is deployed and running
👉 Check Render logs for errors

### CORS error?
👉 Add `ADMIN_APP_URL` in Render environment
👉 Redeploy backend

---

## Complete Example

**Your Render URL:**
```
https://instantpick-backend.onrender.com
```

**Update in api_constants.dart:**
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

**Test:**
```bash
curl https://instantpick-backend.onrender.com/api/health
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://instantpick-backend.onrender.com/api/admin/stats
```

**Build & Deploy:**
```bash
cd admin_app
flutter build web --release
firebase deploy --only hosting
```

**Done!** 🎉

---

## Checklist

- [ ] Got Render URL from dashboard
- [ ] Updated `api_constants.dart`
- [ ] Tested `/api/health`
- [ ] Tested `/api/admin/stats`
- [ ] Built admin app
- [ ] Deployed to Firebase
- [ ] Tested login

---

**Total Time: 10 minutes**

**Your Admin Key:** `V!v3k@29#20$Secure`

🚀 **Ready to manage!**
