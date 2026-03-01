# 🚀 Production Deployment - Step by Step

## Complete Production Setup for Render

### Phase 1: Backend Setup (5 minutes)

#### Step 1: Render Environment Variables
Render Dashboard → Your Backend Service → Environment

Add these variables:
```
ADMIN_KEY=Adm!n@2024#Pr0d$Secur3%Key^Render&2024
ADMIN_APP_URL=https://your-admin-app.web.app
SHOP_APP_URL=https://your-shop-app.web.app
USER_APP_URL=https://your-user-app.web.app
NODE_ENV=production
```

#### Step 2: Push Backend Changes
```bash
cd backend
git add .
git commit -m "Add admin routes and production CORS"
git push origin main
```

Render automatically redeploy karega (2-3 minutes).

#### Step 3: Verify Backend
```bash
curl https://your-backend.onrender.com/api/health
```

Expected:
```json
{"status":"OK","message":"Marketplace API is running"}
```

### Phase 2: Admin App Deployment (10 minutes)

#### Option A: Firebase Hosting (Recommended)

**Step 1: Install Firebase CLI**
```bash
npm install -g firebase-tools
```

**Step 2: Login**
```bash
firebase login
```

**Step 3: Create Firebase Project**
- Go to https://console.firebase.google.com
- Create new project: "marketplace-admin"
- Enable Hosting

**Step 4: Update API URL**
Edit `admin_app/lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-backend.onrender.com/api';
```

**Step 5: Update Firebase Project ID**
Edit `admin_app/.firebaserc`:
```json
{
  "projects": {
    "default": "marketplace-admin"
  }
}
```

**Step 6: Build & Deploy**
```bash
cd admin_app
flutter build web --release
firebase deploy --only hosting
```

**Step 7: Get Your URL**
```
✔ Deploy complete!
Hosting URL: https://marketplace-admin.web.app
```

#### Option B: Vercel (Alternative)

**Step 1: Install Vercel CLI**
```bash
npm install -g vercel
```

**Step 2: Update API URL** (same as Firebase)

**Step 3: Build**
```bash
cd admin_app
flutter build web --release
```

**Step 4: Deploy**
```bash
cd build/web
vercel --prod
```

#### Option C: Render Static Site

**Step 1: Update API URL** (same as above)

**Step 2: Push to GitHub**
```bash
git add .
git commit -m "Admin app production ready"
git push origin main
```

**Step 3: Render Dashboard**
- New → Static Site
- Connect GitHub repo
- Root directory: `admin_app`
- Build command: `flutter build web --release`
- Publish directory: `build/web`
- Deploy

### Phase 3: Update CORS (2 minutes)

#### Step 1: Get Admin App URL
After deployment, you'll get URL like:
```
https://marketplace-admin.web.app
```

#### Step 2: Update Render Environment
Render Dashboard → Backend Service → Environment

Update:
```
ADMIN_APP_URL=https://marketplace-admin.web.app
```

#### Step 3: Redeploy Backend
Render will auto-redeploy when you save environment variables.

### Phase 4: Testing (5 minutes)

#### Test 1: Backend Health
```bash
curl https://your-backend.onrender.com/api/health
```

#### Test 2: Admin API (with your admin key)
```bash
curl -H "adminKey: Adm!n@2024#Pr0d$Secur3%Key^Render&2024" \
  https://your-backend.onrender.com/api/admin/stats
```

Expected:
```json
{
  "success": true,
  "stats": {
    "totalUsers": 0,
    "totalShops": 0,
    ...
  }
}
```

#### Test 3: Admin App Login
1. Open: https://marketplace-admin.web.app
2. Enter admin key: `Adm!n@2024#Pr0d$Secur3%Key^Render&2024`
3. Click Login
4. Dashboard should load

#### Test 4: All Features
- ✅ Dashboard stats load
- ✅ Users screen works
- ✅ Shops screen works
- ✅ Products screen works
- ✅ Orders screen works
- ✅ Logs screen works

### Phase 5: Keep Backend Awake (Optional)

Render free tier sleeps after 15 minutes of inactivity.

#### Option 1: Cron-Job.org (Free)
1. Go to https://cron-job.org
2. Create account
3. Add new cron job:
   - URL: `https://your-backend.onrender.com/api/health`
   - Interval: Every 10 minutes
   - Save

#### Option 2: UptimeRobot (Free)
1. Go to https://uptimerobot.com
2. Create account
3. Add new monitor:
   - Type: HTTP(s)
   - URL: `https://your-backend.onrender.com/api/health`
   - Interval: 5 minutes
   - Save

### Complete URLs

After deployment, update these:

```
Backend API:
https://_____________________.onrender.com/api

Admin Dashboard:
https://_____________________.web.app

Admin Key:
_____________________________________

Shop Owner App:
https://_____________________.web.app

User App:
https://_____________________.web.app
```

### Quick Commands Reference

```bash
# Build admin app
cd admin_app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting

# Deploy to Vercel
cd build/web
vercel --prod

# Test backend
curl https://your-backend.onrender.com/api/health

# Test admin API
curl -H "adminKey: YOUR_KEY" \
  https://your-backend.onrender.com/api/admin/stats
```

### Troubleshooting

**Issue: CORS Error**
```
Solution: Update ADMIN_APP_URL in Render environment variables
```

**Issue: Can't Login**
```
Solution: Check ADMIN_KEY matches in Render and your login
```

**Issue: Backend Sleeping**
```
Solution: Setup cron-job.org to ping every 10 minutes
```

**Issue: Build Failed**
```
Solution: Check Flutter version, run flutter doctor
```

### Security Checklist

- [ ] Strong ADMIN_KEY set (32+ characters)
- [ ] CORS configured with specific origins
- [ ] HTTPS only (no HTTP)
- [ ] Environment variables not in git
- [ ] Admin key shared securely
- [ ] MongoDB Atlas IP whitelist configured

### Cost Summary

```
Backend (Render Free):        $0/month
Admin App (Firebase Free):    $0/month
MongoDB Atlas (Free):         $0/month
Cron Job (Free):             $0/month
Domain (Optional):           $10-15/year

Total: FREE
```

### Upgrade When Needed

**Render Paid ($7/month):**
- No sleep
- Faster
- More resources

**Firebase Paid (Pay as you go):**
- More bandwidth
- Custom domain
- Better performance

### Final Checklist

- [ ] Backend deployed on Render
- [ ] ADMIN_KEY set in Render
- [ ] Admin routes working
- [ ] Admin app built for web
- [ ] Admin app deployed (Firebase/Vercel/Render)
- [ ] API URL updated in admin app
- [ ] CORS configured
- [ ] All features tested
- [ ] Cron job setup (optional)
- [ ] URLs documented
- [ ] Admin key shared securely

### 🎉 Production Ready!

Your admin app is now live and production-ready!

**Next Steps:**
1. Share admin URL with team
2. Share admin key securely
3. Monitor backend logs
4. Setup alerts (optional)
5. Regular backups

**Support:**
- Backend logs: Render Dashboard → Logs
- Admin app: Browser console
- Database: MongoDB Atlas → Metrics
