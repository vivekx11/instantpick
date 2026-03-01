# Admin App Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      ADMIN DASHBOARD APP                     │
│                        (Flutter)                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP + Admin Key
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      BACKEND API                             │
│                    (Express.js)                              │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │           Admin Routes (/api/admin/*)              │    │
│  │                                                     │    │
│  │  • Authentication Middleware (adminKey check)      │    │
│  │  • Dashboard Stats                                 │    │
│  │  • User Management                                 │    │
│  │  • Shop Management                                 │    │
│  │  • Product Management                              │    │
│  │  • Order Management                                │    │
│  │  • System Logs                                     │    │
│  └────────────────────────────────────────────────────┘    │
│                              │                               │
└──────────────────────────────┼───────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   MongoDB Atlas   │
                    │                   │
                    │  • Users          │
                    │  • Shops          │
                    │  • Products       │
                    │  • Orders         │
                    └──────────────────┘
```

## Flutter App Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         main.dart                            │
│                    (App Entry Point)                         │
│                                                              │
│  • MultiProvider Setup                                       │
│  • Theme Configuration                                       │
│  • AuthWrapper (Login/Dashboard routing)                     │
└─────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
┌──────────────────────────┐   ┌──────────────────────────┐
│   AdminProvider          │   │    ApiService            │
│   (State Management)     │◄──│    (HTTP Client)         │
│                          │   │                          │
│  • Authentication        │   │  • API Calls             │
│  • Data Loading          │   │  • Error Handling        │
│  • CRUD Operations       │   │  • Response Parsing      │
└──────────────────────────┘   └──────────────────────────┘
                │
                │ Provides Data To
                │
    ┌───────────┴───────────┐
    │                       │
    ▼                       ▼
┌─────────┐           ┌─────────────┐
│ Login   │           │  Dashboard  │
│ Screen  │           │   Screen    │
└─────────┘           └─────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│    Users     │   │    Shops     │   │   Products   │
│   Screen     │   │   Screen     │   │   Screen     │
└──────────────┘   └──────────────┘   └──────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Orders     │   │    Logs      │   │              │
│   Screen     │   │   Screen     │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
```

## Data Flow

### 1. Authentication Flow
```
User Input (Admin Key)
        │
        ▼
AdminProvider.login()
        │
        ▼
ApiService.getStats(adminKey)
        │
        ▼
Backend: Admin Auth Middleware
        │
        ├─ Valid Key ──► Return Stats ──► Save to SharedPreferences
        │
        └─ Invalid Key ──► Return 403 ──► Show Error
```

### 2. Data Loading Flow
```
Screen Init
        │
        ▼
Provider.loadData()
        │
        ▼
ApiService.getData(adminKey)
        │
        ▼
Backend: Fetch from MongoDB
        │
        ▼
Return JSON Response
        │
        ▼
Provider Updates State
        │
        ▼
UI Rebuilds with New Data
```

### 3. CRUD Operations Flow
```
User Action (Block/Delete/Update)
        │
        ▼
Confirmation Dialog
        │
        ▼
Provider.performAction()
        │
        ▼
ApiService.apiCall(adminKey, data)
        │
        ▼
Backend: Validate & Execute
        │
        ▼
MongoDB: Update/Delete
        │
        ▼
Return Success Response
        │
        ▼
Provider.reloadData()
        │
        ▼
UI Updates
```

## Security Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Layers                           │
└─────────────────────────────────────────────────────────────┘

Layer 1: Client-Side
├─ Admin Key Storage (SharedPreferences - Encrypted)
├─ HTTPS Only Communication
└─ Input Validation

Layer 2: Network
├─ Admin Key in Headers
├─ CORS Configuration
└─ Rate Limiting (Future)

Layer 3: Backend
├─ Admin Auth Middleware
│  └─ Validates adminKey from headers
│     └─ Compares with process.env.ADMIN_KEY
│        ├─ Match ──► Allow Request
│        └─ No Match ──► Return 403
│
└─ Route Protection
   └─ All /api/admin/* routes require authentication

Layer 4: Database
├─ MongoDB Authentication
├─ Connection String Security
└─ Data Validation (Mongoose Schemas)
```

## Component Hierarchy

```
MaterialApp
└─ MultiProvider
   └─ AdminProvider
      └─ AuthWrapper
         ├─ LoginScreen (if not authenticated)
         │  └─ Form
         │     ├─ Admin Key Input
         │     └─ Login Button
         │
         └─ DashboardScreen (if authenticated)
            ├─ AppBar
            │  ├─ Title
            │  ├─ Refresh Button
            │  └─ Logout Button
            │
            ├─ Stats Grid
            │  ├─ Total Users Card
            │  ├─ Total Shops Card
            │  ├─ Total Products Card
            │  ├─ Total Orders Card
            │  ├─ Active Shops Card
            │  └─ Pending Orders Card
            │
            └─ Quick Actions
               ├─ Manage Users Button
               ├─ Manage Shops Button
               ├─ Manage Products Button
               ├─ Manage Orders Button
               └─ System Logs Button
```

## API Request/Response Format

### Request Format
```json
{
  "headers": {
    "adminKey": "your_super_secret_admin_key_here",
    "Content-Type": "application/json"
  },
  "method": "GET|POST|PATCH|DELETE",
  "body": {
    // Request data (for POST/PATCH)
  }
}
```

### Response Format
```json
{
  "success": true|false,
  "message": "Optional message",
  "data": {
    // Response data
  }
}
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    AdminProvider                             │
│                                                              │
│  State Variables:                                            │
│  ├─ _isAuthenticated: bool                                   │
│  ├─ _adminKey: String?                                       │
│  ├─ _stats: Map?                                             │
│  ├─ _users: List                                             │
│  ├─ _shops: List                                             │
│  ├─ _products: List                                          │
│  ├─ _orders: List                                            │
│  └─ _logs: Map?                                              │
│                                                              │
│  Methods:                                                    │
│  ├─ login(adminKey)                                          │
│  ├─ logout()                                                 │
│  ├─ loadDashboardData()                                      │
│  ├─ loadUsers()                                              │
│  ├─ loadShops()                                              │
│  ├─ loadProducts()                                           │
│  ├─ loadOrders()                                             │
│  ├─ loadLogs()                                               │
│  ├─ toggleUserStatus(userId)                                 │
│  ├─ deleteUser(userId)                                       │
│  ├─ toggleShopStatus(shopId)                                 │
│  ├─ deleteShop(shopId)                                       │
│  ├─ deleteProduct(productId)                                 │
│  └─ updateOrderStatus(orderId, status)                       │
│                                                              │
│  Each method:                                                │
│  1. Calls ApiService                                         │
│  2. Updates state                                            │
│  3. Calls notifyListeners()                                  │
│  4. UI rebuilds automatically                                │
└─────────────────────────────────────────────────────────────┘
```

## Error Handling

```
Try-Catch Blocks
        │
        ├─ Network Error
        │  └─ Show "Connection Failed" message
        │
        ├─ Authentication Error (403)
        │  └─ Logout & redirect to login
        │
        ├─ Server Error (500)
        │  └─ Show "Server Error" message
        │
        └─ Unknown Error
           └─ Show generic error message
```

## Performance Optimizations

1. **Lazy Loading**: Data loaded only when screen opens
2. **Caching**: Images cached using cached_network_image
3. **Pull to Refresh**: Manual refresh instead of auto-polling
4. **Efficient Rebuilds**: Provider only rebuilds affected widgets
5. **Pagination**: Future enhancement for large datasets

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Production Setup                          │
└─────────────────────────────────────────────────────────────┘

Admin App (Flutter)
├─ Web: Hosted on Firebase Hosting / Vercel
├─ Android: APK on device / Play Store
└─ iOS: IPA on device / App Store

Backend API
├─ Hosted on Render / Railway / Heroku
├─ Environment Variables (ADMIN_KEY, MONGODB_URI)
└─ HTTPS enabled

Database
└─ MongoDB Atlas (Cloud)
   ├─ Cluster with authentication
   └─ IP whitelist configured
```

## Future Enhancements

1. **Analytics Dashboard**
   - Charts using fl_chart
   - Revenue tracking
   - User growth metrics

2. **Advanced Features**
   - Push notifications
   - Export to CSV
   - Bulk operations
   - Advanced filters

3. **Security**
   - Two-factor authentication
   - Role-based access control
   - Audit logs
   - Session management

4. **Performance**
   - Pagination
   - Search functionality
   - Real-time updates (WebSocket)
   - Offline support
