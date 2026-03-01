# ✅ Deployment Checklist - Existing Render Server

## Pre-Deployment

- [ ] Backend code ready in `backend/` folder
- [ ] Admin app code ready in `admin_app/` folder
- [ ] Git repository setup
- [ ] Render account active
- [ ] Backend already deployed on Render

---

## Backend Deployment (5 minutes)

### Push Changes
- [ ] Navigate to backend folder: `cd backend`
- [ ] Stage changes: `git add .`
- [ ] Commit: `git commit -m "Add admin routes"`
- [ ] Push: `git push origin main`
- [ ] Wait for Render auto-deploy (2-3 minutes)

### Environment Variables
- [ ] Open Render Dashboard
- [ ] Select your backend service
- [ ] Go to Environment tab
- [ ] Add `ADMIN_KEY` with strong value
- [ ] Save (triggers redeploy)

### Verify Backend
- [ ] Test health: `curl https://YOUR-BACKEND.onrender.com/api/health`
- [ ] Test admin API: `curl -H "adminKey: YOUR_KEY" https://YOUR-BACKEND.onrender.com/api/admin/stats`
- [ ] Check Render logs for errors
- [ ] Verify all routes working

---

## Admin App Deployment (10 minutes)

### Update Configuration
- [ ] Open `admin_app/lib/core/constants/api_constants.dart`
- [ ] Update `baseUrl` with your Render backend URL
- [ ] Save file

### Build
- [ ] Navigate: `cd admin_app`
- [ ] Get dependencies: `flutter pub get`
- [ ] Build: `flutter build web --release`
- [ ] Wait for build to complete (2-3 minutes)
- [ ] Verify `build/web` folder created

### Deploy (Choose One)

#### Option A: Firebase
- [ ] Install Firebase CLI: `npm install -g firebase-tools`
- [ ] Login: `firebase login`
- [ ] Create Firebase project at console.firebase.google.com
- [ ] Update `.firebaserc` with project ID
- [ ] Deploy: `firebase deploy --only hosting`
- [ ] Note down hosting URL

#### Option B: Vercel
- [ ] Install Vercel CLI: `npm install -g vercel`
- [ ] Navigate: `cd build/web`
- [ ] Deploy: `vercel --prod`
- [ ] Follow prompts
- [ ] Note down deployment URL

#### Option C: Render Static
- [ ] Push to GitHub
- [ ] Render Dashboard → New Static Site
- [ ] Connect repository
- [ ] Root: `admin_app`
- [ ] Build: `flutter build web --release`
- [ ] Publish: `build/web`
- [ ] Deploy

---

## CORS Configuration (2 minutes)

- [ ] Get admin app URL from deployment
- [ ] Render Dashboard → Backend Service → Environment
- [ ] Add `ADMIN_APP_URL` with admin app URL
- [ ] Save (triggers redeploy)
- [ ] Wait for redeploy to complete

---

## Testing (5 minutes)

### Backend Tests
- [ ] Health check returns OK
- [ ] Admin stats API works with key
- [ ] No errors in Render logs
- [ ] All admin endpoints responding

### Admin App Tests
- [ ] Open admin app URL
- [ ] Login page loads
- [ ] Enter admin key
- [ ] Login successful
- [ ] Dashboard loads with stats
- [ ] Users screen works
- [ ] Shops screen works
- [ ] Products screen works
- [ ] Orders screen works
- [ ] Logs screen works
- [ ] No CORS errors in console
- [ ] All CRUD operations work

---

## Post-Deployment (5 minutes)

### Documentation
- [ ] Note backend URL
- [ ] Note admin app URL
- [ ] Note admin key (securely)
- [ ] Update team documentation

### Monitoring Setup (Optional)
- [ ] Setup UptimeRobot for backend
- [ ] Configure alerts
- [ ] Add monitoring dashboard

### Security
- [ ] Verify HTTPS on all URLs
- [ ] Check CORS configuration
- [ ] Verify admin key strength
- [ ] Test unauthorized access blocked

---

## Final Verification

### URLs Working
- [ ] Backend: `https://YOUR-BACKEND.onrender.com/api`
- [ ] Health: `https://YOUR-BACKEND.onrender.com/api/health`
- [ ] Admin: `https://YOUR-ADMIN-APP.web.app`

### Environment Variables Set
- [ ] `MONGODB_URI`
- [ ] `ADMIN_KEY`
- [ ] `ADMIN_APP_URL`
- [ ] `NODE_ENV=production`

### Features Working
- [ ] Login with admin key
- [ ] View dashboard stats
- [ ] Manage users
- [ ] Manage shops
- [ ] Manage products
- [ ] Manage orders
- [ ] View system logs
- [ ] Logout works

---

## Troubleshooting Checklist

### If Login Fails
- [ ] Check admin key matches Render environment
- [ ] Verify backend is running
- [ ] Check browser console for errors
- [ ] Test admin API with curl

### If CORS Error
- [ ] Verify `ADMIN_APP_URL` set in Render
- [ ] Check URL matches exactly (no trailing slash)
- [ ] Redeploy backend after adding URL
- [ ] Clear browser cache

### If Backend Slow
- [ ] Render free tier sleeps after 15 min
- [ ] First request takes 30-60 seconds
- [ ] Setup UptimeRobot to keep awake
- [ ] Consider upgrading to paid tier

### If Build Fails
- [ ] Run `flutter doctor`
- [ ] Check Flutter version
- [ ] Clear build cache: `flutter clean`
- [ ] Rebuild: `flutter build web --release`

---

## Success Criteria

✅ Backend deployed and running
✅ Admin routes accessible
✅ Admin app deployed and accessible
✅ Login works with admin key
✅ All screens functional
✅ No CORS errors
✅ All CRUD operations work
✅ Logs show activity
✅ No console errors

---

## Time Estimate

```
Backend Push:           2 minutes
Environment Setup:      3 minutes
Admin App Build:        3 minutes
Admin App Deploy:       5 minutes
CORS Configuration:     2 minutes
Testing:               5 minutes
-----------------------------------
Total:                 20 minutes
```

---

## Cost Summary

```
Backend (Render):       Already running
Admin App (Firebase):   FREE
MongoDB Atlas:          Already running
Monitoring (Optional):  FREE
-----------------------------------
Additional Cost:        ₹0
```

---

## Next Steps After Deployment

1. **Share Access:**
   - [ ] Share admin URL with team
   - [ ] Share admin key securely
   - [ ] Document login process

2. **Monitor:**
   - [ ] Check Render logs daily
   - [ ] Monitor system logs in admin app
   - [ ] Track user activity

3. **Maintain:**
   - [ ] Change admin key monthly
   - [ ] Update dependencies regularly
   - [ ] Backup database weekly

4. **Optimize:**
   - [ ] Setup cron job for backend
   - [ ] Add analytics (optional)
   - [ ] Implement caching (optional)

---

## Emergency Contacts

```
Render Support:    https://render.com/docs
Firebase Support:  https://firebase.google.com/support
Flutter Docs:      https://flutter.dev/docs
MongoDB Support:   https://www.mongodb.com/support
```

---

## 🎉 Deployment Complete!

When all checkboxes are ✅, your admin app is live!

**Congratulations! 🚀**

---

**Print this checklist and check off items as you complete them!**
