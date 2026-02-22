# MongoDB Connection Fix

## Problem
Backend cannot connect to MongoDB Atlas:
```
❌ MongoDB connection failed: querySrv ECONNREFUSED _mongodb._tcp.cluster0.ryerrti.mongodb.net
```

## Solutions

### Option 1: Check MongoDB Atlas Settings (Recommended)

1. **Go to MongoDB Atlas Dashboard**
   - https://cloud.mongodb.com

2. **Check Network Access**
   - Click "Network Access" in left sidebar
   - Ensure IP `0.0.0.0/0` is whitelisted (allows all IPs)
   - Or add your current IP address

3. **Check Database User**
   - Click "Database Access"
   - Verify user `viveksawji06_db_user` exists
   - Password: `vivek@2920`
   - Ensure user has "Read and write to any database" permission

4. **Get Fresh Connection String**
   - Click "Database" → "Connect"
   - Choose "Connect your application"
   - Copy connection string
   - Replace in `.env` file

### Option 2: Use Local MongoDB

Install MongoDB locally:

```bash
# Download MongoDB Community Server
# https://www.mongodb.com/try/download/community

# After installation, start MongoDB
mongod
```

Update `.env`:
```env
MONGODB_URI=mongodb://localhost:27017/marketplace
```

### Option 3: Check Firewall/Network

1. **Check if port 27017 is blocked**
   ```bash
   telnet cluster0.ryerrti.mongodb.net 27017
   ```

2. **Disable VPN** if using one

3. **Check antivirus/firewall** settings

4. **Try different network** (mobile hotspot)

### Option 4: Use Alternative MongoDB Connection String

Try standard connection string instead of SRV:

```env
MONGODB_URI=mongodb://viveksawji06_db_user:vivek%402920@cluster0-shard-00-00.ryerrti.mongodb.net:27017,cluster0-shard-00-01.ryerrti.mongodb.net:27017,cluster0-shard-00-02.ryerrti.mongodb.net:27017/marketplace?ssl=true&replicaSet=atlas-xxxxx-shard-0&authSource=admin&retryWrites=true&w=majority
```

## Quick Test

After fixing, test connection:

```bash
cd backend
npm start
```

Should see:
```
✅ MongoDB connected successfully
🚀 Server running on port 3000
```

## Current Status

- Backend: Deployed at https://instantpick-backend.onrender.com
- User App: Connected to Render backend
- Shop Owner App: Connected to Render backend

## Temporary Solution

Use Render deployed backend (if already deployed):

### User App
Update `user_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

### Rebuild APK
```bash
cd user_app
flutter build apk --release --no-tree-shake-icons
```

## Next Steps

1. Fix MongoDB Atlas connection
2. Or deploy backend to Render (MongoDB will work there)
3. Update both apps to use same backend URL
4. Rebuild APKs

## MongoDB Atlas Checklist

- [ ] Network Access: 0.0.0.0/0 whitelisted
- [ ] Database User exists with correct password
- [ ] User has read/write permissions
- [ ] Connection string is correct
- [ ] No VPN/firewall blocking connection
- [ ] DNS can resolve cluster0.ryerrti.mongodb.net
