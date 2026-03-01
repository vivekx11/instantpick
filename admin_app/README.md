# Admin Dashboard App

Complete admin panel for managing marketplace operations.

## Features

### 1. Dashboard
- Real-time statistics
- Total users, shops, products, orders
- Active shops count
- Pending orders count
- Quick action buttons

### 2. User Management
- View all users
- Block/Unblock users
- Delete users
- View user details (name, email, phone, join date)

### 3. Shop Management
- View all shops with owner details
- Activate/Deactivate shops
- Delete shops (removes all products)
- View shop information

### 4. Product Management
- View all products
- Delete products
- View product details (name, price, stock, category)
- Product images

### 5. Order Management
- View all orders
- Update order status (pending, confirmed, ready, completed, cancelled)
- View order details (customer, shop, items, total)
- Order history

### 6. System Logs
- Recent users
- Recent shops
- Recent products
- Recent orders
- Activity timeline

## Setup

### Backend Setup

1. Add admin key to `.env`:
```env
ADMIN_KEY=your_super_secret_admin_key_here
```

2. Backend already configured with admin routes

### Flutter App Setup

1. Install dependencies:
```bash
cd admin_app
flutter pub get
```

2. Update API URL in `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://your-backend-url/api';
```

3. Run the app:
```bash
flutter run
```

## Login

Use your admin key from `.env` file to login.

## API Endpoints

All endpoints require `adminKey` header:

- `GET /api/admin/stats` - Dashboard statistics
- `GET /api/admin/users` - All users
- `PATCH /api/admin/users/:id/toggle-status` - Block/Unblock user
- `DELETE /api/admin/users/:id` - Delete user
- `GET /api/admin/shops` - All shops
- `PATCH /api/admin/shops/:id/toggle-status` - Activate/Deactivate shop
- `DELETE /api/admin/shops/:id` - Delete shop
- `GET /api/admin/products` - All products
- `DELETE /api/admin/products/:id` - Delete product
- `GET /api/admin/orders` - All orders
- `PATCH /api/admin/orders/:id/status` - Update order status
- `GET /api/admin/logs` - System logs

## Security

- Admin key authentication required for all operations
- Secure key storage using SharedPreferences
- No unauthorized access possible

## Permissions

Admin has full control over:
- Users (view, block, delete)
- Shops (view, activate/deactivate, delete)
- Products (view, delete)
- Orders (view, update status)
- System logs (view all activity)

## Tech Stack

- Flutter 3.8+
- Provider (State Management)
- HTTP (API calls)
- SharedPreferences (Local storage)
- Cached Network Image
- FL Chart (Analytics)
- Intl (Date formatting)
