# ⚡ Quick Deploy - Existing Render Server

## 3 Simple Steps (10 minutes total)

### Step 1: Push Backend (2 minutes)

```bash
cd backend
git add .
git commit -m "Add admin routes"
git push origin main
```

Render automatically redeploy karega.

### Step 2: Add Admin Key (1 minute)

**Render Dashboard:**
1. Your backend service select karo
2. Environment tab
3. Add: `ADMIN_KEY=Admin@2024#Secure$Key`
4. Save

### Step 3: Deploy Admin App (7 minutes)

**Update backend URL:**
```dart
// admin_app/lib/core/constants/api_constants.dart
static const String baseUrl = 'https://YOUR-BACKEND.onrender.com/api';
```

**Build & Deploy:**
```bash
cd admin_app
flutter build web --release
firebase login
firebase deploy --only hosting
```

## Done! 🎉

**Your URLs:**
```
Backend: https://your-backend.onrender.com/api
Admin:   https://your-project.web.app
```

**Login:**
```
Admin Key: Admin@2024#Secure$Key
```

---

## Test Commands

```bash
# Test backend
curl https://your-backend.onrender.com/api/health

# Test admin API
curl -H "adminKey: YOUR_KEY" \
  https://your-backend.onrender.com/api/admin/stats
```

---

## Troubleshooting

**CORS Error?**
```
Render → Environment → Add:
ADMIN_APP_URL=https://your-admin-app.web.app
```

**Can't Login?**
```
Check ADMIN_KEY in Render matches your login key
```

**Backend Sleeping?**
```
Setup UptimeRobot: https://uptimerobot.com
Monitor: https://your-backend.onrender.com/api/health
```

---

## Complete Setup

```
✅ Backend: Already on Render
✅ Admin Routes: Added
✅ Admin Key: Set in environment
✅ Admin App: Deployed on Firebase
✅ CORS: Configured
✅ Cost: FREE
```

**Total Time: 10 minutes**
**Additional Cost: ₹0**

🚀 **Ready to manage your marketplace!**
