# 🔑 Admin Key Verification Guide

## Current Issue

Backend deployed successfully but admin API returning **403 Forbidden**

This means ADMIN_KEY environment variable is not being recognized.

---

## ✅ Solution: Verify & Fix Admin Key

### Step 1: Go to Render Dashboard

```
https://dashboard.render.com
```

### Step 2: Select Your Backend

Click on: **instantpick-backend**

### Step 3: Check Environment Variables

1. Click **Environment** tab (left sidebar)
2. Look for `ADMIN_KEY` in the list
3. Check if it exists and has correct value

---

## 🔍 What to Check

### Scenario A: ADMIN_KEY Exists

**Check the value:**
- Should be exactly: `V!v3k@29#20$Secure`
- No extra spaces
- No quotes around it
- Case sensitive

**If value is wrong:**
1. Click edit (pencil icon)
2. Update value to: `V!v3k@29#20$Secure`
3. Click **Save Changes**
4. Wait 2-3 minutes for redeploy

---

### Scenario B: ADMIN_KEY Missing

**Add it:**
1. Click **Add Environment Variable**
2. Key: `ADMIN_KEY`
3. Value: `V!v3k@29#20$Secure`
4. Click **Save Changes**
5. Wait 2-3 minutes for redeploy

---

### Scenario C: ADMIN_KEY Looks Correct

**Try manual redeploy:**
1. Go to **Manual Deploy** (top right)
2. Click **Deploy latest commit**
3. Wait 2-3 minutes

---

## 🧪 Test After Each Step

### Test Command:

**Windows PowerShell:**
```powershell
$headers = @{
    "adminKey" = "V!v3k@29#20$Secure"
}
Invoke-RestMethod -Uri "https://instantpick-backend.onrender.com/api/admin/stats" -Headers $headers
```

**Or use curl (Git Bash):**
```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://instantpick-backend.onrender.com/api/admin/stats
```

**Expected Success Response:**
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

---

## 📸 Screenshot Guide

### 1. Environment Tab Should Show:

```
KEY                 VALUE
ADMIN_KEY          V!v3k@29#20$Secure
MONGODB_URI        mongodb+srv://...
IMAGEKIT_...       ...
NODE_ENV           production
```

### 2. Correct Format:

```
✅ ADMIN_KEY=V!v3k@29#20$Secure
❌ ADMIN_KEY="V!v3k@29#20$Secure"  (no quotes)
❌ ADMIN_KEY= V!v3k@29#20$Secure   (no space)
❌ admin_key=V!v3k@29#20$Secure    (wrong case)
```

---

## 🔧 Common Issues & Fixes

### Issue 1: Value Has Quotes

**Wrong:** `"V!v3k@29#20$Secure"`
**Right:** `V!v3k@29#20$Secure`

**Fix:** Remove quotes from value

---

### Issue 2: Extra Spaces

**Wrong:** ` V!v3k@29#20$Secure ` (spaces before/after)
**Right:** `V!v3k@29#20$Secure`

**Fix:** Remove all spaces

---

### Issue 3: Wrong Key Name

**Wrong:** `admin_key` or `AdminKey` or `ADMINKEY`
**Right:** `ADMIN_KEY` (exact case)

**Fix:** Use exact name: `ADMIN_KEY`

---

### Issue 4: Special Characters Issue

**If special characters causing problems:**

**Alternative key (simpler):**
```
ADMIN_KEY=Vivek2920Secure
```

Then update in:
- Render environment
- `backend/.env` (local)
- `test_admin_api.js`
- Admin app login

---

## 📱 After Admin Key Works

### 1. Test Backend
```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://instantpick-backend.onrender.com/api/admin/stats
```

### 2. Install APK
```
File: admin_app/build/app/outputs/flutter-apk/app-release.apk
```

### 3. Login to App
```
Admin Key: V!v3k@29#20$Secure
```

### 4. Start Managing!

---

## 🎯 Quick Fix Checklist

- [ ] Go to Render Dashboard
- [ ] Select instantpick-backend
- [ ] Click Environment tab
- [ ] Find ADMIN_KEY
- [ ] Verify value: `V!v3k@29#20$Secure`
- [ ] No quotes, no spaces
- [ ] Save if changed
- [ ] Wait 3 minutes
- [ ] Test admin API
- [ ] Should return stats ✅

---

## 💡 Pro Tip

**If still not working after all fixes:**

1. Delete ADMIN_KEY completely
2. Save (triggers redeploy)
3. Wait for redeploy to complete
4. Add ADMIN_KEY again
5. Save (triggers another redeploy)
6. Wait and test

Sometimes a fresh add works better!

---

## 🎊 Success Indicators

Admin key is working when:

✅ Test command returns stats (not 403)
✅ No "Unauthorized" or "Forbidden" errors
✅ Response has `"success": true`
✅ Stats object has user/shop/product counts

---

## 📞 Still Not Working?

**Check Render Logs:**
1. Dashboard → instantpick-backend
2. Click **Logs** tab
3. Look for:
   - "ADMIN_KEY" mentions
   - Authentication errors
   - Environment variable errors

**Share logs if needed for debugging**

---

**Next:** Once admin API works, install APK and login!

🚀 **You're almost there!**
