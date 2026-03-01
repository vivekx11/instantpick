# 🔑 Admin Key Setup Guide

## Your Admin Key

```
V!v3k@29#20$Secure
```

**⚠️ Keep this key secret and secure!**

---

## Setup Locations

### 1. Local Development (.env file)

**File:** `backend/.env`

```env
ADMIN_KEY=V!v3k@29#20$Secure
```

✅ Already added!

---

### 2. Render Production (Environment Variables)

**Steps:**

1. Go to https://dashboard.render.com
2. Select your backend service
3. Click **Environment** tab
4. Click **Add Environment Variable**
5. Add:
   ```
   Key: ADMIN_KEY
   Value: V!v3k@29#20$Secure
   ```
6. Click **Save Changes**

Render will automatically redeploy (2-3 minutes).

---

### 3. Test API Script

**File:** `test_admin_api.js`

```javascript
const ADMIN_KEY = 'V!v3k@29#20$Secure';
```

✅ Already updated!

**Test command:**
```bash
node test_admin_api.js
```

---

## Login to Admin App

**URL:** Your deployed admin app URL

**Admin Key:** `V!v3k@29#20$Secure`

**Steps:**
1. Open admin app
2. Enter: `V!v3k@29#20$Secure`
3. Click Login
4. Dashboard will open

---

## Test Commands

### Test Backend Health
```bash
curl https://your-backend.onrender.com/api/health
```

### Test Admin API
```bash
curl -H "adminKey: V!v3k@29#20$Secure" \
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

---

## Security Tips

✅ **Strong Key:** Your key has 20 characters with special characters
✅ **Never Commit:** .env file is in .gitignore
✅ **Secure Storage:** Only in environment variables
✅ **HTTPS Only:** Always use HTTPS in production

**Additional Security:**
- Change key every 3 months
- Don't share in plain text (use encrypted channels)
- Monitor failed login attempts
- Use different keys for staging/production

---

## Troubleshooting

### Can't Login?
**Check:**
- Key entered exactly: `V!v3k@29#20$Secure`
- No extra spaces
- Backend is running
- ADMIN_KEY set in Render

### 403 Unauthorized?
**Solution:**
- Verify ADMIN_KEY in Render environment
- Check backend logs
- Redeploy backend after adding key

### Backend Not Responding?
**Check:**
- Backend deployed successfully
- No errors in Render logs
- Health endpoint working

---

## Quick Reference

**Local Testing:**
```bash
# Start backend
cd backend
npm start

# Test admin API
curl -H "adminKey: V!v3k@29#20$Secure" \
  http://localhost:3000/api/admin/stats
```

**Production:**
```bash
# Test admin API
curl -H "adminKey: V!v3k@29#20$Secure" \
  https://your-backend.onrender.com/api/admin/stats
```

---

## Files Updated

✅ `backend/.env` - Local development
✅ `backend/.env.example` - Example file
✅ `test_admin_api.js` - Test script

**Still Need to Update:**
- Render Environment Variables (manual step)

---

## Next Steps

1. **Push to GitHub:**
   ```bash
   cd backend
   git add .env.example
   git commit -m "Update admin key example"
   git push origin main
   ```

2. **Update Render:**
   - Dashboard → Environment → Add ADMIN_KEY
   - Value: `V!v3k@29#20$Secure`
   - Save

3. **Test:**
   ```bash
   curl -H "adminKey: V!v3k@29#20$Secure" \
     https://your-backend.onrender.com/api/admin/stats
   ```

4. **Login to Admin App:**
   - Open admin app URL
   - Enter: `V!v3k@29#20$Secure`
   - Start managing!

---

## 🎉 Admin Key Ready!

Your admin key `V!v3k@29#20$Secure` is configured and ready to use!

**Remember:** Keep it secret, keep it safe! 🔐
