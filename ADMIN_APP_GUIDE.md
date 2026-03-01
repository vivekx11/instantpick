# Admin App Complete Guide

## Overview

Admin Dashboard app banaya gaya hai jo complete marketplace ko manage karta hai.

## Features

### 1. Dashboard (Home Screen)
- **Stats Cards**: Total users, shops, products, orders
- **Active Shops**: Kitne shops active hain
- **Pending Orders**: Kitne orders pending hain
- **Quick Actions**: Direct navigation to all sections

### 2. User Management
**Kya kar sakte hain:**
- Sabhi users ki list dekh sakte hain
- User ko block/unblock kar sakte hain
- User ko delete kar sakte hain
- User details: Name, Email, Phone, Join Date

**Kaise use karein:**
1. Dashboard se "Manage Users" click karein
2. User card expand karein details dekhne ke liye
3. "Block" button se user ko block karein
4. "Delete" button se user ko permanently delete karein

### 3. Shop Management
**Kya kar sakte hain:**
- Sabhi shops ki list with owner details
- Shop ko activate/deactivate kar sakte hain
- Shop ko delete kar sakte hain (saare products bhi delete ho jayenge)
- Shop details: Name, Address, Owner info

**Kaise use karein:**
1. Dashboard se "Manage Shops" click karein
2. Shop card expand karein
3. "Deactivate" se shop band kar sakte hain
4. "Delete" se shop aur uske products delete ho jayenge

### 4. Product Management
**Kya kar sakte hain:**
- Sabhi products ki list with images
- Product ko delete kar sakte hain
- Product details: Name, Price, Stock, Category, Description

**Kaise use karein:**
1. Dashboard se "Manage Products" click karein
2. Product card expand karein
3. "Delete Product" se product remove kar sakte hain

### 5. Order Management
**Kya kar sakte hain:**
- Sabhi orders ki list
- Order status update kar sakte hain
- Order details: Customer, Shop, Items, Total Amount

**Order Status:**
- `pending` - Naya order
- `confirmed` - Shop ne confirm kiya
- `ready` - Order ready for pickup
- `completed` - Order complete
- `cancelled` - Order cancelled

**Kaise use karein:**
1. Dashboard se "Manage Orders" click karein
2. Order card expand karein
3. Dropdown se status change karein

### 6. System Logs
**Kya dekh sakte hain:**
- Recent 5 users
- Recent 5 shops
- Recent 5 products
- Recent 10 orders
- Timestamp ke saath

**Kaise use karein:**
1. Dashboard se "System Logs" click karein
2. Sabhi recent activity ek jagah dikhegi

## Setup Instructions

### Backend Setup

1. `.env` file mein admin key add karein:
```env
ADMIN_KEY=your_super_secret_admin_key_here
```

2. Backend restart karein:
```bash
cd backend
npm start
```

### Admin App Setup

1. Dependencies install karein:
```bash
cd admin_app
flutter pub get
```

2. API URL update karein `lib/core/constants/api_constants.dart` mein:
```dart
static const String baseUrl = 'http://localhost:3000/api';
// Production ke liye: 'https://your-backend.onrender.com/api'
```

3. App run karein:
```bash
flutter run
```

## Login Process

1. App open karein
2. Admin key enter karein (jo `.env` mein set kiya hai)
3. "Login" button click karein
4. Dashboard open ho jayega

## Security

- Har API call mein admin key required hai
- Bina admin key ke koi operation nahi ho sakta
- Admin key securely stored hai SharedPreferences mein
- Logout karne se key delete ho jata hai

## Troubleshooting

### Backend se connect nahi ho raha
- Check karein backend running hai ya nahi
- API URL sahi hai ya nahi
- Admin key `.env` mein set hai ya nahi

### Login nahi ho raha
- Admin key sahi enter kiya hai ya nahi
- Backend mein same admin key set hai ya nahi
- Internet connection check karein

### Data load nahi ho raha
- Refresh button click karein
- Pull to refresh karein
- Backend logs check karein

## API Endpoints

Sabhi endpoints ko `adminKey` header chahiye:

```
GET    /api/admin/stats                      - Dashboard stats
GET    /api/admin/users                      - All users
PATCH  /api/admin/users/:id/toggle-status    - Block/Unblock
DELETE /api/admin/users/:id                  - Delete user
GET    /api/admin/shops                      - All shops
PATCH  /api/admin/shops/:id/toggle-status    - Activate/Deactivate
DELETE /api/admin/shops/:id                  - Delete shop
GET    /api/admin/products                   - All products
DELETE /api/admin/products/:id               - Delete product
GET    /api/admin/orders                     - All orders
PATCH  /api/admin/orders/:id/status          - Update status
GET    /api/admin/logs                       - System logs
```

## Admin Permissions

Admin ke paas complete control hai:

✅ Users ko block/unblock/delete kar sakta hai
✅ Shops ko activate/deactivate/delete kar sakta hai
✅ Products ko delete kar sakta hai
✅ Orders ka status change kar sakta hai
✅ Sabhi system logs dekh sakta hai
✅ Real-time statistics dekh sakta hai

## Best Practices

1. **Regular Monitoring**: Dashboard regularly check karein
2. **Quick Response**: Pending orders ko jaldi handle karein
3. **User Management**: Suspicious users ko block karein
4. **Shop Quality**: Inactive shops ko deactivate karein
5. **Product Quality**: Low quality products ko remove karein
6. **Logs Review**: System logs regularly check karein

## Future Enhancements

- Analytics charts
- Export data to CSV
- Push notifications
- Advanced filters
- Bulk operations
- User messaging
- Report generation
