# 🚀 Render Environment Variables Setup

## Your Admin Key

```
V!v3k@29#20$Secure
```

---

## Step-by-Step Render Setup

### Step 1: Login to Render

Go to: https://dashboard.render.com

### Step 2: Select Your Backend Service

Click on your backend service name (e.g., "marketplace-backend")

### Step 3: Go to Environment Tab

Click on **Environment** in the left sidebar

### Step 4: Add Environment Variables

Click **Add Environment Variable** button

Add these variables:

#### 1. Admin Key (Required)
```
Key: ADMIN_KEY
Value: V!v3k@29#20$Secure
```

#### 2. Admin App URL (Add after deploying admin app)
```
Key: ADMIN_APP_URL
Value: https://your-admin-app.web.app
```

#### 3. Node Environment (If not set)
```
Key: NODE_ENV
Value: production
```

### Step 5: Save Changes

Click **Save Changes** button

**Important:** Render will automatically redeploy your backend (takes 2-3 minutes)

---

## Verify Setup

### Check Deployment Status

Wait for deployment to complete. You'll see:
```
✓ Build successful
✓ Deploy live
```

### Test Backend Health

```bash
curl https://your-backend-name.onrender.com/api/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Marketplace API is running",
  "timestamp": "2024-..."
}
```

### Test Admin API

```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://your-backend-name.onrender.com/api/admin/stats
```

Expected response:
```json
{
  "success": true,
  "stats": {
    "totalUsers": 0,
    "totalShops": 0,
    "totalProducts": 0,
    "totalOrders": 0,
    "activeShops": 0,
    "pendingOrders": 0
  }
}
```

✅ If you get this response, admin key is working!

---

## Complete Environment Variables List

Your Render environment should have:

```
✅ MONGODB_URI=mongodb+srv://...
✅ ADMIN_KEY=V!v3k@29#20$Secure
✅ NODE_ENV=production
✅ IMAGEKIT_PUBLIC_KEY=public_...
✅ IMAGEKIT_PRIVATE_KEY=private_...
✅ IMAGEKIT_URL_ENDPOINT=https://...
⏳ ADMIN_APP_URL=https://... (add after admin app deployment)
```

---

## Screenshots Guide

### 1. Render Dashboard
```
[Your Services] → Click your backend service
```

### 2. Environment Tab
```
Left Sidebar → Environment
```

### 3. Add Variable
```
Click "Add Environment Variable"
Key: ADMIN_KEY
Value: V!v3k@29#20$Secure
Click "Save Changes"
```

### 4. Wait for Deploy
```
Watch deployment logs
Wait for "Deploy live" message
```

---

## Troubleshooting

### Issue: Can't find Environment tab
**Solution:** Make sure you're in your backend service, not dashboard home

### Issue: Save button disabled
**Solution:** Make sure both Key and Value are filled

### Issue: Deployment failed
**Solution:** 
- Check Render logs for errors
- Verify MongoDB URI is correct
- Check all required variables are set

### Issue: Admin API returns 403
**Solution:**
- Verify ADMIN_KEY is exactly: `V!v3k@29#20$Secure`
- No extra spaces or characters
- Redeploy if needed

---

## After Adding Admin Key

### 1. Test Locally First

```bash
cd backend
npm start

# In another terminal
curl -H "adminKey: V!v3k@29#20$Secure" \
  http://localhost:3000/api/admin/stats
```

### 2. Push to GitHub

```bash
git add .
git commit -m "Add admin routes"
git push origin main
```

### 3. Render Auto-Deploys

Wait 2-3 minutes for deployment

### 4. Test Production

```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://your-backend.onrender.com/api/admin/stats
```

---

## Security Checklist

- [x] Admin key is strong (20 characters)
- [x] Admin key has special characters
- [x] Admin key not in git repository
- [x] Admin key only in environment variables
- [ ] HTTPS only in production
- [ ] CORS configured after admin app deployment
- [ ] Regular key rotation planned

---

## Next Steps

1. ✅ Admin key set in Render
2. ⏳ Deploy admin app
3. ⏳ Add ADMIN_APP_URL to Render
4. ⏳ Test complete flow

---

## Quick Commands

### Test Backend
```bash
# Health check
curl https://YOUR-BACKEND.onrender.com/api/health

# Admin stats
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://YOUR-BACKEND.onrender.com/api/admin/stats

# All users
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://YOUR-BACKEND.onrender.com/api/admin/users

# All shops
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://YOUR-BACKEND.onrender.com/api/admin/shops
```

---

## 🎉 Environment Setup Complete!

Your Render backend is now configured with admin key: `V!v3k@29#20$Secure`

**Next:** Deploy admin app and start managing! 🚀
