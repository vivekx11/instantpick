# Backend Deployment Checklist

## ✅ Completed

1. **Backend Code Ready**
   - Server listens on `0.0.0.0` (all interfaces)
   - Uses `process.env.PORT` for Render
   - Environment-based configuration
   - Production error handling
   - CORS enabled
   - Health check endpoint: `/api/health`

2. **Files Created**
   - `.gitignore` - Excludes node_modules, .env, test files
   - `README.md` - Complete API documentation
   - `RENDER_DEPLOYMENT.md` - Step-by-step deployment guide
   - `create_geo_index.js` - MongoDB geo index setup

3. **Features Added**
   - Geolocation support with 2dsphere index
   - Location-based shop queries
   - OpenStreetMap integration ready
   - ImageKit image upload (with base64 fallback)
   - Order management with pickup codes
   - Shop and product CRUD operations

4. **Git Repository**
   - Code committed to local git
   - Ready to push to: https://github.com/vivekx11/instantpick-backend

## 📋 Next Steps

### 1. Push to GitHub
```bash
cd backend
git push origin main
```

### 2. Setup MongoDB Atlas
1. Go to https://cloud.mongodb.com
2. Create free cluster
3. Create database user
4. Whitelist IP: `0.0.0.0/0` (all IPs)
5. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/instantpick
   ```

### 3. Setup ImageKit (Optional)
1. Go to https://imagekit.io
2. Sign up for free account
3. Get from Dashboard:
   - Public Key
   - Private Key
   - URL Endpoint

### 4. Deploy on Render
1. Go to https://dashboard.render.com
2. Click "New +" → "Web Service"
3. Connect GitHub: `vivekx11/instantpick-backend`
4. Configure:
   - Name: `instantpick-backend`
   - Branch: `main`
   - Build: `npm install`
   - Start: `npm start`
   - Instance: Free

5. Add Environment Variables:
   ```
   PORT=3000
   NODE_ENV=production
   MONGODB_URI=your_mongodb_atlas_uri
   IMAGEKIT_PUBLIC_KEY=your_key
   IMAGEKIT_PRIVATE_KEY=your_key
   IMAGEKIT_URL_ENDPOINT=your_endpoint
   JWT_SECRET=random_secret_key
   ```

6. Click "Create Web Service"

### 5. After Deployment
1. Wait 2-5 minutes for deployment
2. Get URL: `https://instantpick-backend.onrender.com`
3. Test health check:
   ```bash
   curl https://instantpick-backend.onrender.com/api/health
   ```

4. Run geo index setup (one-time):
   - Use Render Shell or create Job
   - Run: `node create_geo_index.js`

### 6. Update Flutter Apps
Update API base URL in both apps:

**Shop Owner App** - `shop_owner_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

**User App** - `user_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

## 🔍 Verification

After deployment, test these endpoints:

```bash
# Health check
curl https://instantpick-backend.onrender.com/api/health

# Get shops
curl https://instantpick-backend.onrender.com/api/shops

# Get products
curl https://instantpick-backend.onrender.com/api/products

# Get orders
curl https://instantpick-backend.onrender.com/api/orders
```

## 📊 API Endpoints

### Core APIs
- `GET /api/health` - Health check
- `GET /api/shops` - List shops
- `POST /api/shops` - Create shop
- `GET /api/products` - List products
- `POST /api/products` - Create product
- `GET /api/orders` - List orders
- `POST /api/orders` - Create order

### Location APIs
- `POST /api/location/shop/location` - Save shop location
- `POST /api/location/shops/nearby` - Get nearby shops
- `POST /api/location/shops/deliverable` - Get deliverable shops
- `GET /api/location/shops/radius` - Get shops in radius

### Upload API
- `POST /api/upload` - Upload image (ImageKit or base64)

## 🚨 Important Notes

1. **Free Tier Limitations**
   - Render: Service sleeps after 15 min inactivity
   - First request after sleep: 30-60 seconds
   - MongoDB Atlas: 512 MB storage limit

2. **Security**
   - Never commit `.env` file
   - Use strong JWT_SECRET
   - MongoDB IP whitelist: `0.0.0.0/0`

3. **Monitoring**
   - Check Render logs for errors
   - Monitor MongoDB Atlas metrics
   - Set up alerts for downtime

## 📚 Documentation

- Full deployment guide: `backend/RENDER_DEPLOYMENT.md`
- API documentation: `backend/README.md`
- OpenStreetMap guide: `OPENSTREETMAP_MIGRATION_GUIDE.md`

## 🆘 Troubleshooting

### Service won't start
- Check Render logs
- Verify MONGODB_URI format
- Ensure all env vars are set

### Database connection failed
- Check MongoDB Atlas IP whitelist
- Verify connection string
- Check database user credentials

### 502 Bad Gateway
- Service is starting (wait 1-2 minutes)
- Check logs for errors

## ✨ Features Ready

- ✅ Shop management with geolocation
- ✅ Product management with images
- ✅ Order management with pickup codes
- ✅ User authentication
- ✅ Nearby shop queries
- ✅ OpenStreetMap integration
- ✅ ImageKit image upload
- ✅ Production-ready error handling
- ✅ Health monitoring
- ✅ Auto-deploy from GitHub

## 🎯 Your URLs

After deployment:
- Backend: `https://instantpick-backend.onrender.com`
- Health: `https://instantpick-backend.onrender.com/api/health`
- GitHub: `https://github.com/vivekx11/instantpick-backend`
