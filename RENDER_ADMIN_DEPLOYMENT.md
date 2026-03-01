# 🚀 Admin App - Render Production Deployment Guide

## Overview

Admin app ko production mein deploy karne ke liye complete guide.

## Prerequisites

✅ Render account (free tier works)
✅ GitHub repository
✅ Backend already deployed on Render
✅ MongoDB Atlas setup

## Step 1: Backend Configuration (Already Done)

Backend already deployed hai, bas admin routes add karne hain:

### 1.1 Render Dashboard mein jao
```
https://dashboard.render.com
```

### 1.2 Backend service select karo

### 1.3 Environment Variables add karo

**Important:** Render dashboard mein Environment tab mein jao aur add karo:

```
ADMIN_KEY=your_super_secret_admin_key_production_2024
```

**Security Tips:**
- Strong key use karo (minimum 32 characters)
- Special characters include karo
- Regular change karo

Example strong key:
```
ADMIN_KEY=Adm!n@2024#Pr0d$Secur3%Key^Render&2024
```

### 1.4 Backend redeploy karo

Render automatically redeploy karega jab GitHub pe push karoge.

## Step 2: Admin App Configuration

### 2.1 Update API URL

`admin_app/lib/core/constants/api_constants.dart` mein:

```dart
static const String baseUrl = 'https://your-backend-app.onrender.com/api';
```

**Replace `your-backend-app` with your actual Render backend URL**

Example:
```dart
static const String baseUrl = 'https://marketplace-backend-xyz.onrender.com/api';
```

### 2.2 Build for Production

**For Web (Recommended for Admin):**
```bash
cd admin_app
flutter build web --release
```

**For Android APK:**
```bash
flutter build apk --release
```

**For iOS (Mac only):**
```bash
flutter build ios --release
```

## Step 3: Deploy Admin Web App

### Option A: Firebase Hosting (Recommended - Free)

#### 3.1 Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### 3.2 Login to Firebase
```bash
firebase login
```

#### 3.3 Initialize Firebase
```bash
cd admin_app
firebase init hosting
```

Select:
- Use existing project or create new
- Public directory: `build/web`
- Single-page app: Yes
- Automatic builds: No

#### 3.4 Deploy
```bash
firebase deploy --only hosting
```

Your admin app will be live at:
```
https://your-project.web.app
```

### Option B: Vercel (Alternative - Free)

#### 3.1 Install Vercel CLI
```bash
npm install -g vercel
```

#### 3.2 Deploy
```bash
cd admin_app/build/web
vercel
```

Follow prompts and your app will be live!

### Option C: Render Static Site (Free)

#### 3.1 Create `render.yaml` in admin_app folder:
```yaml
services:
  - type: web
    name: admin-dashboard
    env: static
    buildCommand: flutter build web --release
    staticPublishPath: build/web
    routes:
      - type: rewrite
        source: /*
        destination: /index.html
```

#### 3.2 Push to GitHub

#### 3.3 Render Dashboard:
- New → Static Site
- Connect GitHub repo
- Select `admin_app` folder
- Deploy

## Step 4: Security Configuration

### 4.1 Update CORS in Backend

`backend/server.js` mein:

```javascript
const allowedOrigins = [
  'https://your-admin-app.web.app',
  'https://your-admin-app.vercel.app',
  'https://admin-dashboard.onrender.com'
];

app.use(cors({
  origin: function(origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));
```

### 4.2 Environment Variables Security

Render dashboard mein ensure karo:
```
ADMIN_KEY=<strong-secret-key>
MONGODB_URI=<your-mongodb-atlas-uri>
NODE_ENV=production
```

## Step 5: Testing Production Deployment

### 5.1 Test Backend API

```bash
curl -H "adminKey: your_admin_key" \
  https://your-backend.onrender.com/api/admin/stats
```

Expected response:
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

### 5.2 Test Admin App

1. Open deployed admin app URL
2. Enter admin key
3. Login
4. Check dashboard loads
5. Test all features

## Step 6: Production Checklist

- [ ] Backend deployed on Render
- [ ] ADMIN_KEY set in Render environment variables
- [ ] Admin routes working (test with curl)
- [ ] Admin app built for web
- [ ] Admin app deployed (Firebase/Vercel/Render)
- [ ] API URL updated in admin app
- [ ] CORS configured for admin app domain
- [ ] Admin key is strong and secure
- [ ] All features tested in production
- [ ] Documentation updated with URLs

## Production URLs Structure

```
Backend API:
https://your-backend.onrender.com/api

Admin Dashboard:
https://your-admin-app.web.app
or
https://your-admin-app.vercel.app
or
https://admin-dashboard.onrender.com

Shop Owner App:
https://your-shop-app.web.app

User App:
https://your-user-app.web.app
```

## Admin Access

### Login Credentials
```
URL: https://your-admin-app.web.app
Admin Key: (Check Render environment variables)
```

### Share with Team
```
Admin Dashboard: https://your-admin-app.web.app
Admin Key: <share-securely>
```

## Monitoring & Maintenance

### 1. Check Backend Logs
```
Render Dashboard → Your Service → Logs
```

### 2. Monitor API Health
```
https://your-backend.onrender.com/api/health
```

### 3. Update Admin Key (if needed)
```
Render Dashboard → Environment → Edit ADMIN_KEY → Save
```

### 4. Redeploy Admin App
```bash
cd admin_app
flutter build web --release
firebase deploy --only hosting
```

## Troubleshooting

### Issue: Can't login
**Solution:**
- Check ADMIN_KEY in Render matches what you're entering
- Check backend logs for authentication errors
- Verify API URL is correct in admin app

### Issue: CORS error
**Solution:**
- Add admin app domain to CORS allowedOrigins
- Redeploy backend
- Clear browser cache

### Issue: 404 on routes
**Solution:**
- Ensure single-page app configuration in hosting
- Check routes are properly configured
- Verify build/web folder has all files

### Issue: Slow loading
**Solution:**
- Render free tier sleeps after inactivity
- First request takes 30-60 seconds
- Upgrade to paid tier for always-on

## Performance Tips

1. **Keep Backend Awake:**
   - Use cron-job.org to ping every 10 minutes
   - Ping URL: `https://your-backend.onrender.com/api/health`

2. **Optimize Admin App:**
   - Use cached_network_image for images
   - Implement pagination for large lists
   - Add loading indicators

3. **Database Optimization:**
   - Create indexes in MongoDB
   - Use aggregation pipelines
   - Limit query results

## Security Best Practices

1. **Admin Key:**
   - Use strong, random keys
   - Change regularly
   - Never commit to git
   - Share securely (encrypted)

2. **HTTPS Only:**
   - All production URLs use HTTPS
   - No HTTP allowed

3. **Access Control:**
   - Limit admin access to trusted IPs (optional)
   - Use VPN for extra security
   - Monitor access logs

4. **Regular Updates:**
   - Update dependencies regularly
   - Monitor security advisories
   - Patch vulnerabilities quickly

## Cost Breakdown (Free Tier)

```
Backend (Render):        $0/month (free tier)
Admin App (Firebase):    $0/month (free tier)
MongoDB Atlas:           $0/month (free tier)
Domain (optional):       $10-15/year

Total: FREE (or ~$1/month with domain)
```

## Upgrade Path

When you need more:

1. **Render Paid ($7/month):**
   - Always-on (no sleep)
   - Faster performance
   - More resources

2. **MongoDB Atlas Paid ($9/month):**
   - More storage
   - Better performance
   - Automated backups

3. **Custom Domain ($10-15/year):**
   - Professional look
   - Better branding

## Quick Deploy Commands

### Deploy Everything:
```bash
# 1. Backend (auto-deploys on git push)
cd backend
git add .
git commit -m "Add admin routes"
git push origin main

# 2. Admin App
cd ../admin_app
flutter build web --release
firebase deploy --only hosting
```

### Update Admin Key:
```bash
# Render Dashboard → Environment → ADMIN_KEY → Save
# Then redeploy backend (automatic)
```

## Support & Resources

- Render Docs: https://render.com/docs
- Firebase Hosting: https://firebase.google.com/docs/hosting
- Flutter Web: https://flutter.dev/web
- MongoDB Atlas: https://www.mongodb.com/docs/atlas/

## Final Production URLs

Update these after deployment:

```
Backend API: https://_____________________.onrender.com/api
Admin App:   https://_____________________.web.app
Admin Key:   ________________________________
```

---

**🎉 Your admin app is now production-ready!**

Share the admin URL and key securely with your team.
