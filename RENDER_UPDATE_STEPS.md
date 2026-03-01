# 📋 Render Environment Variable Update - Step by Step

## 🎯 Goal

Update ADMIN_KEY from old value to: **`Vivek2920SecureAdmin`**

---

## 📸 Visual Step-by-Step Guide

### Step 1: Open Render Dashboard

**URL:** https://dashboard.render.com

**Login with your credentials**

---

### Step 2: Find Your Backend Service

**Look for:** `instantpick-backend`

**Click on it** to open service details

---

### Step 3: Navigate to Environment Tab

**Left Sidebar:**
- Overview
- Events
- **Environment** ← Click this
- Logs
- Shell
- Settings

---

### Step 4: Locate ADMIN_KEY

**You will see a list like:**

```
┌─────────────────┬──────────────────────────┬────────┐
│ KEY             │ VALUE                    │ ACTION │
├─────────────────┼──────────────────────────┼────────┤
│ ADMIN_KEY       │ V!v3k@29#20$Secure      │ [Edit] │
│ MONGODB_URI     │ mongodb+srv://...        │ [Edit] │
│ IMAGEKIT_...    │ ...                      │ [Edit] │
│ NODE_ENV        │ production               │ [Edit] │
└─────────────────┴──────────────────────────┴────────┘
```

---

### Step 5: Edit ADMIN_KEY

**Click the [Edit] button** (pencil icon) next to ADMIN_KEY

**A popup/modal will open:**

```
┌────────────────────────────────────────┐
│ Edit Environment Variable              │
├────────────────────────────────────────┤
│ Key:   ADMIN_KEY                       │
│                                        │
│ Value: [V!v3k@29#20$Secure          ] │
│        ↑ Delete this old value         │
│                                        │
│        [Vivek2920SecureAdmin        ] │
│        ↑ Type this new value           │
│                                        │
│ [Cancel]              [Save Changes]   │
└────────────────────────────────────────┘
```

---

### Step 6: Update the Value

**Delete old value:**
- Select all text in Value field
- Press Delete/Backspace

**Type new value:**
```
Vivek2920SecureAdmin
```

**Important:**
- ✅ No quotes
- ✅ No spaces before/after
- ✅ Exact case (capital V, capital S, capital A)
- ✅ No special characters

---

### Step 7: Save Changes

**Click:** `Save Changes` button

**You will see:**
```
✓ Environment variable updated
  Deploying new version...
```

---

### Step 8: Wait for Deployment

**Render will automatically redeploy your service**

**Watch the Events tab or Logs tab:**

```
==> Deploying...
==> Building...
==> Starting service...
==> Your service is live 🎉
```

**This takes 2-3 minutes**

---

### Step 9: Verify Deployment

**Check Logs tab for:**

```
✅ MongoDB connected successfully
🚀 Server running on port 3001
📱 API Base URL: https://instantpick-backend.onrender.com/api
```

**Look for any errors** - there should be none!

---

### Step 10: Test Backend

**Open new browser tab and visit:**

```
https://instantpick-backend.onrender.com/api/health
```

**Should show:**
```json
{
  "status": "OK",
  "message": "Marketplace API is running",
  "timestamp": "2026-02-26T..."
}
```

---

### Step 11: Test Admin Authentication

**Run test script:**

```bash
node test_new_admin_key.js
```

**Expected output:**
```
🧪 Testing Admin API with new key...

1️⃣ Testing Health Check...
✅ Health Check: OK

2️⃣ Testing Admin Stats (Authentication)...
   Status Code: 200
✅ Admin Authentication Successful!
   Stats: {
     "totalUsers": 0,
     "totalShops": 0,
     ...
   }

3️⃣ Testing Admin Users List...
✅ Users List Retrieved
   Total Users: 0
```

---

### Step 12: Login to Admin App

**Open admin app on your phone**

**Enter admin key:**
```
Vivek2920SecureAdmin
```

**Click Login**

**✅ Dashboard should open!**

---

## 🔍 Troubleshooting

### Issue 1: Still Getting 403 Error

**Possible causes:**
1. Environment variable not saved properly
2. Deployment not completed
3. Typo in admin key value

**Solution:**
1. Go back to Render Environment tab
2. Check ADMIN_KEY value again
3. Should be exactly: `Vivek2920SecureAdmin`
4. If wrong, edit and save again
5. Wait for redeploy

---

### Issue 2: Can't Find ADMIN_KEY in Environment

**It might be missing!**

**Add it:**
1. Click **Add Environment Variable** button
2. Key: `ADMIN_KEY`
3. Value: `Vivek2920SecureAdmin`
4. Click **Add**
5. Wait for redeploy

---

### Issue 3: Deployment Failed

**Check Logs tab for errors**

**Common errors:**
- MongoDB connection failed
- Missing other environment variables
- Syntax errors in code

**Solution:**
- Fix the error shown in logs
- Trigger manual deploy if needed

---

### Issue 4: Admin Key Works in Test but Not in App

**Check app's API URL:**

File: `admin_app/lib/core/constants/api_constants.dart`

Should be:
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

If wrong, rebuild APK.

---

## ✅ Success Indicators

**You know it's working when:**

1. ✅ Render shows "Service is live"
2. ✅ Health check returns OK
3. ✅ Test script shows all green checkmarks
4. ✅ No 403 errors in logs
5. ✅ Admin app login successful
6. ✅ Dashboard loads with stats

---

## 📝 Quick Reference

**New Admin Key:**
```
Vivek2920SecureAdmin
```

**Backend URL:**
```
https://instantpick-backend.onrender.com
```

**Test Command:**
```bash
node test_new_admin_key.js
```

**Health Check:**
```
https://instantpick-backend.onrender.com/api/health
```

---

## 🎊 After Successful Update

**You can now:**

1. ✅ Login to admin app
2. ✅ View dashboard stats
3. ✅ Manage users
4. ✅ Manage shops
5. ✅ Manage products
6. ✅ Manage orders
7. ✅ View system logs

**Full admin control! 💪**

---

## 💡 Pro Tips

### Tip 1: Save Admin Key Somewhere Safe

Write it down or save in password manager:
```
Vivek2920SecureAdmin
```

### Tip 2: Check Logs Regularly

Render Dashboard → Logs tab

Monitor for:
- Authentication attempts
- Errors
- Performance issues

### Tip 3: Test After Every Change

Always run test script after updating environment variables:
```bash
node test_new_admin_key.js
```

---

## 🚀 You're All Set!

Follow these steps carefully and your admin app will work perfectly!

**Any issues? Check the troubleshooting section above.**

**Happy managing! 🎉**
