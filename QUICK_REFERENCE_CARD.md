# 🎴 Quick Reference Card - Admin App

## 🔑 Admin Key
```
Vivek2920SecureAdmin
```

## 🌐 Backend URL
```
https://instantpick-backend.onrender.com
```

## 🔗 Important Links

### Render Dashboard
```
https://dashboard.render.com
```

### Health Check
```
https://instantpick-backend.onrender.com/api/health
```

### Admin API Stats
```
https://instantpick-backend.onrender.com/api/admin/stats
```

---

## 🧪 Test Commands

### Test Backend
```bash
node test_new_admin_key.js
```

### Test with curl (Git Bash)
```bash
curl -H "adminKey: Vivek2920SecureAdmin" \
  https://instantpick-backend.onrender.com/api/admin/stats
```

### Test with PowerShell
```powershell
$headers = @{ "adminKey" = "Vivek2920SecureAdmin" }
Invoke-RestMethod -Uri "https://instantpick-backend.onrender.com/api/admin/stats" -Headers $headers
```

---

## 📱 Admin App Info

### APK Location
```
admin_app/build/app/outputs/flutter-apk/app-release.apk
```

### APK Size
```
21.9 MB
```

### Login Credentials
```
Admin Key: Vivek2920SecureAdmin
```

---

## 🔧 Render Environment Variables

### Required Variables
```
ADMIN_KEY=Vivek2920SecureAdmin
MONGODB_URI=mongodb+srv://viveksawji06_db_user:vivek%402920@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority&appName=Cluster0
IMAGEKIT_PUBLIC_KEY=public_MZcZO6q7SzfnaJfrLejtLINJwGs=
IMAGEKIT_PRIVATE_KEY=private_7ww2tdm2YNlEDhErQMBxCuLi+sU=
IMAGEKIT_URL_ENDPOINT=https://ik.imagekit.io/zu0iv5zpd
NODE_ENV=production
```

---

## 📋 Quick Fix Steps

### If Admin App Shows "Invalid Admin Key"

1. Go to: https://dashboard.render.com
2. Select: instantpick-backend
3. Click: Environment
4. Edit: ADMIN_KEY
5. Value: `Vivek2920SecureAdmin`
6. Save and wait 3 minutes
7. Login to admin app

---

## ✅ Success Indicators

```
✅ Health check returns: {"status":"OK"}
✅ Test script shows: ✅ Admin Authentication Successful!
✅ Admin app login works
✅ Dashboard loads with stats
✅ No 403 errors
```

---

## 🎯 Admin App Features

### Dashboard
- Total users, shops, products, orders
- Active shops count
- Pending orders count
- Recent orders list

### Users Management
- View all users
- Block/unblock users
- Delete users
- View user details

### Shops Management
- View all shops
- Activate/deactivate shops
- Delete shops (with products)
- View shop details

### Products Management
- View all products
- Update product details
- Delete products
- View by shop

### Orders Management
- View all orders
- Update order status
- View order details
- Filter by status

### System Logs
- Recent users
- Recent shops
- Recent products
- Recent orders
- Activity timeline

---

## 🔍 Troubleshooting Quick Checks

### Check 1: Backend Health
```
https://instantpick-backend.onrender.com/api/health
```
Should return: `{"status":"OK"}`

### Check 2: Render Logs
Dashboard → instantpick-backend → Logs
Look for: "Service is live 🎉"

### Check 3: Environment Variable
Dashboard → instantpick-backend → Environment
ADMIN_KEY should be: `Vivek2920SecureAdmin`

### Check 4: Test Script
```bash
node test_new_admin_key.js
```
Should show: All green checkmarks ✅

---

## 📞 Common Issues & Solutions

### Issue: 403 Forbidden
**Solution:** Update ADMIN_KEY in Render Dashboard

### Issue: 500 Server Error
**Solution:** Check Render logs for errors

### Issue: Connection Failed
**Solution:** Check internet connection, verify backend URL

### Issue: Login Button Not Working
**Solution:** Check if admin key is exactly: `Vivek2920SecureAdmin`

---

## 💾 File Locations

### Backend Files
```
backend/routes/admin.js       - Admin API routes
backend/server.js             - Server configuration
backend/.env                  - Local environment variables
```

### Admin App Files
```
admin_app/lib/main.dart                          - App entry
admin_app/lib/core/constants/api_constants.dart  - API config
admin_app/lib/providers/admin_provider.dart      - State management
admin_app/lib/services/api_service.dart          - API calls
admin_app/lib/screens/login_screen.dart          - Login UI
admin_app/lib/screens/dashboard_screen.dart      - Dashboard
```

### Documentation Files
```
START_HERE_FIX.md                - Main fix guide
SIMPLE_FIX_HINDI.md              - Hindi instructions
URGENT_FIX_ADMIN_KEY.md          - Detailed explanation
RENDER_UPDATE_STEPS.md           - Step-by-step guide
ADMIN_KEY_UPDATE_DIAGRAM.md      - Visual diagrams
ADMIN_TROUBLESHOOTING_FINAL.md   - Troubleshooting
```

---

## 🎯 Remember

### New Admin Key (Changed!)
```
OLD: V!v3k@29#20$Secure
NEW: Vivek2920SecureAdmin
```

### Why Changed?
Special characters (`!@#$`) caused issues in:
- Environment variables
- HTTP headers
- URL encoding

### New Key Benefits
- ✅ No special characters
- ✅ Easy to type
- ✅ No encoding issues
- ✅ Works everywhere

---

## 📱 Admin App Screens

1. **Login Screen** - Enter admin key
2. **Dashboard** - Stats overview
3. **Users Screen** - User management
4. **Shops Screen** - Shop management
5. **Products Screen** - Product management
6. **Orders Screen** - Order management
7. **Logs Screen** - System logs

---

## 🚀 Quick Start

### First Time Setup
1. Update ADMIN_KEY in Render
2. Wait 3 minutes
3. Install APK on phone
4. Open app
5. Enter: `Vivek2920SecureAdmin`
6. Login
7. Start managing!

### Daily Use
1. Open admin app
2. Enter: `Vivek2920SecureAdmin`
3. Login
4. Manage marketplace
5. Done!

---

## 💡 Pro Tips

### Tip 1: Save Admin Key
Write it down or save in password manager

### Tip 2: Check Logs Regularly
Monitor Render logs for issues

### Tip 3: Test After Changes
Always run test script after updates

### Tip 4: Keep APK Safe
Backup APK file for reinstallation

### Tip 5: Monitor Dashboard
Check stats daily for insights

---

## 📊 API Endpoints

### Public Endpoints
```
GET  /api/health                    - Health check
```

### Admin Endpoints (Require adminKey header)
```
GET  /api/admin/stats               - Dashboard stats
GET  /api/admin/users               - All users
PATCH /api/admin/users/:id/toggle-status - Block/unblock user
DELETE /api/admin/users/:id         - Delete user
GET  /api/admin/shops               - All shops
PATCH /api/admin/shops/:id/toggle-status - Activate/deactivate shop
DELETE /api/admin/shops/:id         - Delete shop
GET  /api/admin/products            - All products
PATCH /api/admin/products/:id       - Update product
DELETE /api/admin/products/:id      - Delete product
GET  /api/admin/orders              - All orders
PATCH /api/admin/orders/:id/status  - Update order status
GET  /api/admin/logs                - System logs
```

---

## 🎊 Success!

When everything works:
- ✅ Backend responds to health check
- ✅ Admin API returns stats
- ✅ Admin app login successful
- ✅ Dashboard shows data
- ✅ All features accessible

---

**Keep this card handy for quick reference!** 📌

**Print or bookmark this page!** 🔖
