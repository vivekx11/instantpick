# 🛍️ InstantPick - Complete Marketplace System

## 📋 Project Overview

InstantPick is a comprehensive local marketplace platform that connects shop owners with customers for quick pickup orders. The system consists of three main components:

1. **User App** (Customer-facing Flutter mobile app)
2. **Shop Owner App** (Business management Flutter mobile app)
3. **Backend API** (Node.js + Express + MongoDB server)

## 🎯 Core Concept

The platform enables a "browse online, pickup in-store" model where:
- Shop owners register their businesses and list products
- Customers browse nearby shops and place orders
- Orders are confirmed with a 4-digit pickup PIN
- Shop owners verify the PIN when customers arrive for pickup
- No delivery system - pure pickup-based marketplace

---

## 🏗️ System Architecture

### Three-Tier Architecture

```
┌─────────────────┐     ┌─────────────────┐
│   User App      │     │ Shop Owner App  │
│   (Flutter)     │     │   (Flutter)     │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │    REST API Calls     │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │   Backend   │
              │  (Node.js)  │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │   MongoDB   │
              │  (Database) │
              └─────────────┘
```

---

## 📱 Application Details

### 1. User App (Customer Application)

**Purpose**: Allow customers to discover shops, browse products, and place pickup orders

**Key Features**:

- **Authentication**: Google Sign-In and phone-based authentication
- **Shop Discovery**: Browse all registered shops with categories
- **Location-Based**: Find nearby shops using geolocation
- **Product Browsing**: View products with images, prices, and stock status
- **Shopping Cart**: Add multiple products from the same shop
- **Order Placement**: Create orders with 4-digit pickup PIN
- **Order Tracking**: View order history and current order status
- **QR Code**: Display pickup PIN as QR code for easy scanning
- **Offline Detection**: Shows offline banner when no internet connection
- **Maps Integration**: OpenStreetMap integration for shop locations

**Tech Stack**:
- Flutter SDK 3.8.1+
- Provider (State Management)
- HTTP (API Communication)
- Google Sign-In
- Flutter Map (OpenStreetMap)
- Geolocator (Location Services)
- QR Flutter (QR Code Generation)
- Cached Network Image
- Shimmer & Lottie (UI Animations)

**App Structure**:
```
user_app/lib/
├── core/               # Core configurations
│   ├── constants/      # API URLs, app constants
│   └── theme/          # Yellow-themed UI design
├── models/             # Data models
│   ├── cart_item_model.dart
│   ├── order_model.dart
│   ├── product_model.dart
│   ├── shop_model.dart
│   └── user_model.dart
├── providers/          # State management
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── order_provider.dart
│   └── shop_provider.dart
├── screens/            # UI screens
│   ├── auth/           # Login, OTP verification
│   ├── home/           # Main screen, cart, profile
│   ├── shops/          # Shop listing, shop details
│   ├── orders/         # Order placement, history
│   └── maps/           # Map view of shops
├── services/           # Business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── location_service.dart
│   └── order_service.dart
└── widgets/            # Reusable components
```

---

### 2. Shop Owner App (Business Management)

**Purpose**: Enable shop owners to manage their business, products, and orders

**Key Features**:

- **Shop Registration**: Register business with details, category, and location
- **Authentication**: Google Sign-In with shop owner verification
- **Product Management**: Add, edit, delete products with multiple images
- **Image Upload**: Firebase Storage integration for product images
- **Stock Management**: Track inventory and mark products as available/unavailable
- **Order Management**: View incoming orders, accept/reject orders
- **Pickup Verification**: Scan QR code or enter 4-digit PIN to verify pickup
- **Dashboard**: View sales statistics, revenue, order trends
- **Order History**: Track completed and cancelled orders
- **Profile Management**: Update shop details and settings
- **Offline Detection**: Works offline with sync when connection restored

**Tech Stack**:
- Flutter SDK 3.8.1+
- Provider (State Management)
- HTTP (API Communication)
- Firebase Storage (Image Upload)
- Google Sign-In
- Flutter Map (OpenStreetMap)
- Mobile Scanner (QR Code Scanning)
- FL Chart (Dashboard Analytics)
- Image Picker (Camera/Gallery)
- Shimmer & Lottie (UI Animations)

**App Structure**:
```
shop_owner_app/lib/
├── core/               # Core configurations
│   ├── constants/      # API URLs, app constants
│   └── theme/          # Green-themed UI design
├── models/             # Data models
│   ├── order_model.dart
│   └── shop_owner_model.dart
├── providers/          # State management
│   ├── auth_provider.dart
│   ├── order_provider.dart
│   ├── product_provider.dart
│   └── shop_provider.dart
├── screens/            # UI screens
│   ├── auth/           # Login, shop registration
│   ├── home/           # Main screen, products list
│   ├── dashboard/      # Analytics dashboard
│   ├── orders/         # Order management, verification
│   ├── products/       # Add/edit products
│   └── location/       # Set shop location
├── services/           # Business logic
│   ├── api_service.dart
│   ├── firebase_service.dart
│   ├── order_service.dart
│   ├── photo_upload_service.dart
│   └── dashboard_service.dart
└── widgets/            # Reusable components
```

---

### 3. Backend API (Server)

**Purpose**: Central server handling all business logic, data storage, and API endpoints

**Key Features**:

- **RESTful API**: Clean, organized endpoints for all operations
- **MongoDB Database**: NoSQL database with Mongoose ODM
- **Shop Management**: CRUD operations for shops
- **Product Management**: CRUD operations for products
- **Order System**: Complete order lifecycle management
- **Pickup PIN System**: Generate and verify 4-digit PINs
- **Geospatial Queries**: Find nearby shops using MongoDB 2dsphere indexes
- **Image Upload**: ImageKit integration (with Base64 fallback)
- **Dashboard Analytics**: Aggregated statistics for shop owners
- **User Management**: Track customer data and order history
- **Error Handling**: Comprehensive error handling and validation

**Tech Stack**:
- Node.js (Runtime)
- Express.js (Web Framework)
- MongoDB (Database)
- Mongoose (ODM)
- ImageKit (Image Storage)
- JWT (Authentication)
- Bcrypt (Password Hashing)
- CORS (Cross-Origin Support)
- Multer (File Upload)

**Project Structure**:
```
backend/
├── models/             # Database schemas
│   ├── Shop.js         # Shop model with geolocation
│   ├── Product.js      # Product model with images
│   ├── Order.js        # Order model with pickup PIN
│   └── User.js         # User model
├── routes/             # API endpoints
│   ├── shops.js        # Shop CRUD operations
│   ├── products.js     # Product CRUD operations
│   ├── orders.js       # Order management
│   ├── users.js        # User operations
│   ├── location.js     # Geospatial queries
│   ├── dashboard.js    # Analytics endpoints
│   └── upload_imagekit.js  # Image upload
├── config/             # Configuration files
│   └── imagekit.js     # ImageKit setup
├── server.js           # Main server file
├── package.json        # Dependencies
└── .env                # Environment variables
```

---

## 🗄️ Database Schema

### Shop Collection
```javascript
{
  _id: ObjectId,
  name: String,              // Shop name
  description: String,       // Shop description
  category: String,          // Grocery, Electronics, etc.
  address: String,           // Physical address
  phone: String,             // Contact number
  ownerName: String,         // Owner's name
  ownerId: String,           // Owner's user ID
  email: String,             // Contact email
  imageUrl: String,          // Shop image
  isActive: Boolean,         // Shop status
  isApproved: Boolean,       // Admin approval
  isOpen: Boolean,           // Currently open/closed
  rating: Number,            // Average rating (0-5)
  totalOrders: Number,       // Total orders received
  totalRevenue: Number,      // Total revenue earned
  location: {                // GeoJSON Point
    type: "Point",
    coordinates: [lng, lat]
  },
  deliveryRadius: Number,    // Delivery radius in km
  locationSet: Boolean,      // Location configured
  createdAt: Date,
  updatedAt: Date
}
```

### Product Collection
```javascript
{
  _id: ObjectId,
  name: String,              // Product name
  description: String,       // Product description
  price: Number,             // Price in currency
  shopId: String,            // Reference to shop
  shopName: String,          // Shop name (denormalized)
  category: String,          // Product category
  imageUrls: [String],       // Multiple product images
  isAvailable: Boolean,      // Currently available
  stock: Number,             // Stock quantity
  unit: String,              // piece, kg, liter, etc.
  tags: [String],            // Search tags
  createdAt: Date,
  updatedAt: Date
}
```

### Order Collection
```javascript
{
  _id: ObjectId,
  userId: String,            // Customer user ID
  shopId: ObjectId,          // Reference to shop
  shopName: String,          // Shop name
  shopAddress: String,       // Shop address
  shopLatitude: Number,      // Shop location
  shopLongitude: Number,     // Shop location
  items: [{                  // Order items
    productId: ObjectId,
    productName: String,
    price: Number,
    quantity: Number,
    productImage: String
  }],
  totalAmount: Number,       // Total order amount
  pickupPin: String,         // 4-digit pickup PIN
  status: String,            // Pending, Accepted, Completed, Cancelled
  notes: String,             // Customer notes
  customerName: String,      // Customer name
  expiresAt: Date,           // Order expiry (24 hours)
  acceptedAt: Date,          // When shop accepted
  completedAt: Date,         // When order completed
  cancelledAt: Date,         // When order cancelled
  cancellationReason: String,
  createdAt: Date,
  updatedAt: Date
}
```

### User Collection
```javascript
{
  _id: ObjectId,
  userId: String,            // Unique user ID
  name: String,              // User name
  phone: String,             // Phone number
  email: String,             // Email address
  totalOrders: Number,       // Total orders placed
  totalSpent: Number,        // Total amount spent
  isActive: Boolean,         // Account status
  location: {                // User location
    type: "Point",
    coordinates: [lng, lat]
  },
  address: String,           // Saved address
  locationSet: Boolean,      // Location configured
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🔄 Complete Order Flow

### Step-by-Step Process

1. **Shop Owner Setup**
   - Shop owner downloads Shop Owner App
   - Signs in with Google
   - Registers shop with details (name, category, address, phone)
   - Sets shop location on map
   - Uploads products with images, prices, and stock

2. **Customer Discovery**
   - Customer downloads User App
   - Signs in with Google or phone number
   - Grants location permission
   - Browses nearby shops or all shops
   - Filters by category

3. **Product Browsing**
   - Customer selects a shop
   - Views all products from that shop
   - Checks product details, images, prices
   - Adds products to cart

4. **Order Placement**
   - Customer reviews cart
   - Enters optional notes
   - Places order
   - Receives 4-digit pickup PIN
   - Order status: "Pending"

5. **Shop Owner Notification**
   - Shop owner sees new order in Orders tab
   - Views order details (items, quantities, total)
   - Sees customer name and notes
   - Can accept or reject order

6. **Order Acceptance**
   - Shop owner accepts order
   - Prepares items for pickup
   - Order status: "Accepted"
   - Customer sees updated status

7. **Customer Pickup**
   - Customer arrives at shop
   - Shows 4-digit PIN or QR code
   - Shop owner scans QR or enters PIN
   - System verifies PIN matches order

8. **Order Completion**
   - Upon successful verification, order marked "Completed"
   - Shop statistics updated (total orders, revenue)
   - Customer order history updated
   - Order status: "Completed"

### Order States

```
Pending → Accepted → Completed
   ↓
Cancelled
```

- **Pending**: Order placed, waiting for shop acceptance
- **Accepted**: Shop accepted and preparing order
- **Completed**: Customer picked up order (PIN verified)
- **Cancelled**: Order cancelled by shop or customer

---

## 🔌 API Endpoints

### Shop Endpoints
```
GET    /api/shops                    # Get all shops
GET    /api/shops/:id                # Get shop by ID
POST   /api/shops                    # Create new shop
PUT    /api/shops/:id                # Update shop
DELETE /api/shops/:id                # Delete shop
```

### Product Endpoints
```
GET    /api/products                 # Get all products
GET    /api/products/:id             # Get product by ID
GET    /api/products/shop/:shopId    # Get products by shop
POST   /api/products                 # Create product
PUT    /api/products/:id             # Update product
DELETE /api/products/:id             # Delete product
```

### Order Endpoints
```
GET    /api/orders                   # Get all orders
GET    /api/orders/:id               # Get order by ID
GET    /api/orders/shop/:shopId      # Get shop orders
GET    /api/orders/user/:userId      # Get user orders
POST   /api/orders                   # Create order
PUT    /api/orders/:id/status        # Update order status
POST   /api/orders/verify-pickup     # Verify pickup PIN
```

### Location Endpoints
```
POST   /api/location/shop/location   # Save shop location
POST   /api/location/shops/nearby    # Get nearby shops
POST   /api/location/shops/deliverable  # Get deliverable shops
GET    /api/location/shops/radius    # Get shops within radius
```

### Dashboard Endpoints
```
GET    /api/dashboard/stats/:shopId  # Get shop statistics
GET    /api/dashboard/orders/:shopId # Get order analytics
GET    /api/dashboard/revenue/:shopId # Get revenue data
```

### Upload Endpoints
```
POST   /api/upload                   # Upload image (ImageKit)
POST   /api/upload-base64            # Upload base64 image
```

### User Endpoints
```
GET    /api/users/:userId            # Get user details
POST   /api/users                    # Create user
PUT    /api/users/:userId            # Update user
```

---

## 🎨 UI/UX Design

### User App Theme
- **Primary Color**: Yellow (#FFC107)
- **Accent Color**: Amber
- **Design**: Modern, clean, customer-friendly
- **Navigation**: Bottom navigation bar (Home, Shops, Orders, Profile)
- **Cards**: Elevated cards with shadows
- **Images**: Cached network images with placeholders
- **Loading**: Shimmer effects for better UX
- **Animations**: Lottie animations for empty states

### Shop Owner App Theme
- **Primary Color**: Green (#4CAF50)
- **Accent Color**: Teal
- **Design**: Professional, business-focused
- **Navigation**: Bottom navigation bar (Dashboard, Products, Orders, Profile)
- **Dashboard**: Charts and statistics with FL Chart
- **Scanner**: Built-in QR code scanner for pickup verification
- **Forms**: Clean forms for product management
- **Loading**: Shimmer effects and progress indicators

### Common UI Elements
- Offline detection banner
- Pull-to-refresh functionality
- Error handling with user-friendly messages
- Confirmation dialogs for critical actions
- Toast notifications for feedback
- Responsive layouts for different screen sizes

---

## 🔐 Security Features

### Authentication
- Google Sign-In integration
- Phone number verification with OTP
- JWT token-based authentication
- Secure session management
- User ID generation and validation

### Data Security
- Input validation on all endpoints
- MongoDB injection prevention
- XSS protection
- CORS configuration
- Environment variables for sensitive data
- Password hashing with bcrypt

### Order Security
- Unique 4-digit pickup PINs
- PIN expiry after 24 hours
- Order verification before completion
- Shop owner authorization checks
- User authorization for order access

---

## 🌍 Location Features

### Geospatial Capabilities
- MongoDB 2dsphere indexes for location queries
- Find shops within radius
- Calculate distance between user and shops
- Sort shops by proximity
- Delivery radius configuration per shop

### Map Integration
- OpenStreetMap (free, no API key required)
- Interactive map view
- Shop markers on map
- User location marker
- Tap markers to view shop details
- Navigate to shop location

### Location Permissions
- Request location permission on app start
- Handle permission denied gracefully
- Show location-based features only when permitted
- Manual location entry as fallback

---

## 📦 Image Management

### User App
- Display product images from URLs
- Cached network images for performance
- Placeholder images while loading
- Error handling for broken images

### Shop Owner App
- Image picker (camera or gallery)
- Multiple image upload support
- Firebase Storage integration
- Image compression before upload
- Progress indicators during upload
- Image URL storage in database

### Backend
- ImageKit integration for cloud storage
- Base64 upload as fallback
- Image validation (size, format)
- Secure upload endpoints
- CDN delivery for fast loading

---

## 🚀 Deployment Guide

### Backend Deployment (Render.com)

1. **Prepare Repository**
   - Push backend code to GitHub
   - Ensure `.env` is in `.gitignore`
   - Add `package.json` with start script

2. **Create Render Service**
   - Sign up at render.com
   - Create new Web Service
   - Connect GitHub repository
   - Select backend directory

3. **Configure Environment**
   - Add environment variables:
     - `MONGODB_URI`: MongoDB Atlas connection string
     - `IMAGEKIT_PUBLIC_KEY`: ImageKit public key
     - `IMAGEKIT_PRIVATE_KEY`: ImageKit private key
     - `IMAGEKIT_URL_ENDPOINT`: ImageKit URL endpoint
     - `JWT_SECRET`: Random secret string
     - `NODE_ENV`: production

4. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment
   - Get production URL (e.g., https://your-app.onrender.com)

### MongoDB Setup (MongoDB Atlas)

1. **Create Cluster**
   - Sign up at mongodb.com/cloud/atlas
   - Create free cluster
   - Choose cloud provider and region

2. **Configure Access**
   - Create database user
   - Whitelist IP addresses (0.0.0.0/0 for all)
   - Get connection string

3. **Database Setup**
   - Database name: `marketplace`
   - Collections created automatically by Mongoose

### ImageKit Setup

1. **Create Account**
   - Sign up at imagekit.io
   - Get free tier (20GB storage, 20GB bandwidth)

2. **Get Credentials**
   - Go to Developer Options
   - Copy Public Key, Private Key, URL Endpoint
   - Add to backend environment variables

### Flutter App Deployment

1. **Update API URLs**
   - User App: `lib/core/constants/app_constants.dart`
   - Shop Owner App: `lib/services/api_service.dart`
   - Replace localhost with production URL

2. **Build Release APK**
   ```bash
   # User App
   cd user_app
   flutter build apk --release
   
   # Shop Owner App
   cd shop_owner_app
   flutter build apk --release
   ```

3. **APK Location**
   - User App: `user_app/build/app/outputs/flutter-apk/app-release.apk`
   - Shop Owner App: `shop_owner_app/build/app/outputs/flutter-apk/app-release.apk`

4. **Distribution**
   - Upload to Google Play Store
   - Or distribute APK directly

---

## 🧪 Testing Workflow

### Local Testing

1. **Start Backend**
   ```bash
   cd backend
   npm install
   npm start
   ```

2. **Run User App**
   ```bash
   cd user_app
   flutter pub get
   flutter run
   ```

3. **Run Shop Owner App**
   ```bash
   cd shop_owner_app
   flutter pub get
   flutter run
   ```

### Complete Test Scenario

1. **Shop Owner Registration**
   - Open Shop Owner App
   - Sign in with Google
   - Register shop with details
   - Set location on map
   - Add 3-5 products with images

2. **Customer Order**
   - Open User App
   - Sign in with Google
   - Browse shops
   - Select shop
   - Add products to cart
   - Place order
   - Note the 4-digit PIN

3. **Order Management**
   - Shop Owner App shows new order
   - Accept order
   - Verify pickup PIN
   - Complete order

4. **Verify Data**
   - Check order history in both apps
   - Verify dashboard statistics
   - Check database records

---

## 📊 Key Features Summary

### For Customers (User App)
✅ Easy Google/Phone authentication
✅ Discover local shops by category
✅ Find nearby shops using GPS
✅ Browse products with images
✅ Add to cart and place orders
✅ Get 4-digit pickup PIN
✅ View order history
✅ Track order status
✅ QR code for easy pickup
✅ Offline detection
✅ Map view of shops

### For Shop Owners (Shop Owner App)
✅ Quick shop registration
✅ Google Sign-In
✅ Upload products with multiple images
✅ Manage inventory and stock
✅ Receive order notifications
✅ Accept/reject orders
✅ Scan QR code for pickup verification
✅ View sales dashboard
✅ Track revenue and orders
✅ Order history and analytics
✅ Profile management
✅ Offline support

### Backend Capabilities
✅ RESTful API design
✅ MongoDB with geospatial queries
✅ Pickup PIN generation and verification
✅ Image upload (ImageKit + Base64)
✅ Order lifecycle management
✅ Dashboard analytics
✅ User management
✅ Error handling
✅ CORS support
✅ Environment-based configuration

---

## 🛠️ Technology Stack Summary

### Frontend (Flutter)
- **Language**: Dart
- **Framework**: Flutter 3.8.1+
- **State Management**: Provider
- **HTTP Client**: http package
- **Authentication**: Google Sign-In, Firebase Auth
- **Maps**: Flutter Map (OpenStreetMap)
- **Location**: Geolocator
- **Image Handling**: Cached Network Image, Image Picker
- **QR Code**: QR Flutter, Mobile Scanner
- **Charts**: FL Chart
- **UI Enhancements**: Shimmer, Lottie
- **Storage**: SharedPreferences

### Backend (Node.js)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **ODM**: Mongoose
- **Authentication**: JWT, Bcrypt
- **Image Storage**: ImageKit
- **File Upload**: Multer
- **CORS**: cors package
- **Environment**: dotenv

### Database (MongoDB)
- **Type**: NoSQL Document Database
- **Hosting**: MongoDB Atlas (Cloud)
- **Features**: 
  - Geospatial indexes (2dsphere)
  - Text search indexes
  - Compound indexes
  - Schema validation with Mongoose

### Cloud Services
- **Backend Hosting**: Render.com
- **Database**: MongoDB Atlas
- **Image Storage**: ImageKit / Firebase Storage
- **Authentication**: Google OAuth, Firebase Auth

---

## 📁 Project Structure Overview

```
instantpick/
├── backend/                    # Node.js backend
│   ├── models/                 # Mongoose schemas
│   ├── routes/                 # API endpoints
│   ├── config/                 # Configuration files
│   ├── server.js               # Main server file
│   ├── package.json            # Dependencies
│   └── .env                    # Environment variables
│
├── user_app/                   # Customer Flutter app
│   ├── lib/
│   │   ├── core/               # Constants, theme
│   │   ├── models/             # Data models
│   │   ├── providers/          # State management
│   │   ├── screens/            # UI screens
│   │   ├── services/           # Business logic
│   │   ├── widgets/            # Reusable widgets
│   │   └── main.dart           # App entry point
│   ├── android/                # Android config
│   ├── ios/                    # iOS config
│   └── pubspec.yaml            # Dependencies
│
├── shop_owner_app/             # Shop owner Flutter app
│   ├── lib/
│   │   ├── core/               # Constants, theme
│   │   ├── models/             # Data models
│   │   ├── providers/          # State management
│   │   ├── screens/            # UI screens
│   │   ├── services/           # Business logic
│   │   ├── widgets/            # Reusable widgets
│   │   └── main.dart           # App entry point
│   ├── android/                # Android config
│   ├── ios/                    # iOS config
│   └── pubspec.yaml            # Dependencies
│
└── Documentation/              # Project documentation
    ├── README.md
    ├── EXPLAIN.md              # This file
    ├── DEPLOYMENT_GUIDE.md
    └── Various other guides
```

---

## 🔄 Data Flow Examples

### Example 1: Customer Places Order

```
1. User adds products to cart (CartProvider)
2. User clicks "Place Order"
3. App calls POST /api/orders with:
   - userId
   - shopId
   - items array
   - totalAmount
   - customerName
4. Backend generates 4-digit PIN
5. Backend creates order document
6. Backend returns order with PIN
7. App displays PIN to user
8. App updates OrderProvider
9. User sees order in "Orders" tab
```

### Example 2: Shop Owner Verifies Pickup

```
1. Customer arrives with PIN
2. Shop owner opens "Orders" tab
3. Shop owner clicks "Verify Pickup"
4. Shop owner scans QR or enters PIN
5. App calls POST /api/orders/verify-pickup with:
   - orderId
   - pickupPin
6. Backend validates PIN matches order
7. Backend updates order status to "Completed"
8. Backend updates shop statistics
9. Backend returns success
10. App shows success message
11. Order moves to "Completed" section
```

### Example 3: Finding Nearby Shops

```
1. User opens app
2. App requests location permission
3. User grants permission
4. App gets current coordinates
5. App calls POST /api/location/shops/nearby with:
   - latitude
   - longitude
   - radius (default 10km)
6. Backend uses MongoDB $geoNear query
7. Backend returns shops sorted by distance
8. App displays shops with distance
9. User can view on map or list
```

---

## 🎯 Business Logic

### Pickup PIN System
- **Generation**: Random 4-digit number (1000-9999)
- **Uniqueness**: Not enforced (low collision probability)
- **Expiry**: 24 hours from order creation
- **Verification**: Exact match required
- **Security**: PIN only shown to customer and shop owner

### Order Expiry
- Orders expire 24 hours after creation
- Expired orders cannot be completed
- Automatic cleanup can be implemented
- Shop owners notified of expiring orders

### Stock Management
- Stock decremented on order placement (optional)
- Products marked unavailable when stock = 0
- Shop owners can manually update stock
- Low stock warnings in dashboard

### Shop Approval System
- New shops require admin approval (optional)
- `isApproved` flag in shop model
- Unapproved shops not visible to customers
- Can be automated or manual

### Revenue Tracking
- Calculated from completed orders
- Updated on order completion
- Displayed in dashboard
- Historical data for analytics

---

## 🚨 Error Handling

### Frontend (Flutter Apps)
- Try-catch blocks for API calls
- User-friendly error messages
- Offline detection and handling
- Network timeout handling
- Invalid data validation
- Loading states for async operations

### Backend (Node.js)
- Express error middleware
- Mongoose validation errors
- HTTP status codes (200, 400, 404, 500)
- Detailed error messages in development
- Generic messages in production
- Database connection error handling

### Common Error Scenarios
- **No Internet**: Show offline banner
- **API Timeout**: Retry mechanism
- **Invalid Data**: Validation messages
- **Not Found**: 404 with helpful message
- **Server Error**: Generic error message
- **Authentication Failed**: Redirect to login

---

## 📈 Scalability Considerations

### Current Architecture
- Suitable for small to medium marketplaces
- Single server deployment
- MongoDB Atlas auto-scaling
- ImageKit CDN for images

### Future Enhancements
- **Caching**: Redis for frequently accessed data
- **Load Balancing**: Multiple server instances
- **Microservices**: Separate services for orders, products, etc.
- **Message Queue**: RabbitMQ for order processing
- **Real-time**: WebSockets for live order updates
- **Push Notifications**: Firebase Cloud Messaging
- **Analytics**: Google Analytics, Mixpanel
- **Admin Panel**: Web dashboard for management
- **Payment Integration**: Stripe, PayPal, Razorpay
- **Delivery System**: Add delivery option
- **Rating System**: Customer reviews and ratings
- **Search**: Elasticsearch for advanced search
- **Recommendations**: ML-based product recommendations

---

## 🔧 Configuration Files

### Backend .env
```env
PORT=3000
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/marketplace
IMAGEKIT_PUBLIC_KEY=your_public_key
IMAGEKIT_PRIVATE_KEY=your_private_key
IMAGEKIT_URL_ENDPOINT=https://ik.imagekit.io/your_id
JWT_SECRET=your_random_secret_string
```

### User App Constants
```dart
class AppConstants {
  static const String baseUrl = 'https://your-api.onrender.com/api';
  static const String appName = 'InstantPick';
  static const String appVersion = '1.0.0';
}
```

### Shop Owner App Constants
```dart
class ApiService {
  static const String baseUrl = 'https://your-api.onrender.com/api';
}
```

---

## 📝 Development Guidelines

### Code Style
- Follow Dart style guide for Flutter
- Use ESLint for Node.js
- Meaningful variable names
- Comments for complex logic
- Consistent indentation

### Git Workflow
- Feature branches for new features
- Commit messages: "feat:", "fix:", "docs:"
- Pull requests for code review
- Main branch protected

### Testing
- Unit tests for business logic
- Widget tests for Flutter UI
- API endpoint testing with Postman
- Integration testing for complete flows

### Documentation
- README for each component
- API documentation
- Code comments
- Deployment guides

---

## 🎓 Learning Resources

### Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)

### Node.js & Express
- [Node.js Documentation](https://nodejs.org/docs)
- [Express.js Guide](https://expressjs.com/guide)
- [Mongoose Documentation](https://mongoosejs.com/docs)

### MongoDB
- [MongoDB Manual](https://docs.mongodb.com/manual)
- [Geospatial Queries](https://docs.mongodb.com/manual/geospatial-queries)

---

## 👥 Team & Contributors

**Project Type**: Full-stack marketplace platform
**Development**: Solo/Team project
**License**: MIT

---

## 📞 Support & Contact

For issues, questions, or contributions:
- Create GitHub issues
- Check documentation files
- Review code comments

---

## 🎉 Conclusion

InstantPick is a complete, production-ready marketplace system that demonstrates:
- Full-stack development (Flutter + Node.js + MongoDB)
- Real-world business logic (orders, inventory, payments)
- Modern UI/UX design
- Geospatial features
- Image management
- Authentication and security
- Scalable architecture

The system is ready for deployment and can be extended with additional features like payments, delivery, ratings, and more.

---

**Built with ❤️ using Flutter, Node.js, and MongoDB**

*Last Updated: February 2026*
