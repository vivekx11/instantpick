# Local Marketplace System - Pickup Code System

A streamlined marketplace system with two Flutter applications focused on direct shop-to-customer interactions using unique pickup codes.

## 🎯 System Overview

This system eliminates the need for complex admin panels and focuses on a simple, efficient workflow:
1. **Users** discover shops and place orders
2. **Shop owners** manage their listings and process pickup orders
3. **Pickup codes** facilitate secure, in-person transactions

## 📱 Applications

### 1. User App (Pink Theme) 🩷
**Customer-focused app for shop discovery and ordering**

**Key Features:**
- Shop discovery and search
- Product browsing by shop
- Order placement with 6-digit pickup codes
- No upfront payment required
- Simple pickup process

**Workflow:**
1. Search and browse local shops
2. View products from selected shops
3. Place order and receive pickup code
4. Visit shop with code for payment and pickup

### 2. Shop Owner App (Indigo Theme) 💙
**Business-focused app for shop management and order processing**

**Key Features:**
- Shop listing management
- Product catalog management
- Order acceptance with code verification
- Order packing and notifications
- Payment processing at pickup

**Workflow:**
1. List shop and products on platform
2. Receive orders with pickup codes
3. Verify customer codes
4. Pack orders and notify customers
5. Process payment at pickup

## 🔢 Pickup Code System

### How It Works
- **6-digit codes** generated for each order
- **24-hour expiration** for security
- **No upfront payment** - pay at pickup
- **Simple verification** process for shop owners

### Benefits
- ✅ Reduced fraud risk
- ✅ No payment gateway fees
- ✅ Direct customer interaction
- ✅ Simple dispute resolution
- ✅ Support for local businesses

## 🏗️ Tech Stack
- **Frontend**: Flutter (latest stable) with Dart
- **State Management**: Provider pattern
- **Authentication**: Firebase OTP
- **Storage**: Firebase Storage (for images)
- **Backend**: Node.js + Express API
- **Database**: MongoDB

## 📁 Project Structure
```
marketplace-system/
├── user_app/          # Pink themed customer app
├── shop_owner_app/    # Indigo themed seller app
├── PICKUP_CODE_SYSTEM.md    # Detailed workflow guide
├── MARKETPLACE_SYSTEM_OVERVIEW.md  # System documentation
└── build scripts      # Automated build tools
```

## 🚀 Quick Start

### Build All Apps
```bash
# Windows
build_all_apps.bat

# Or individual builds
build_apps.bat
```

### Development Setup
1. Ensure Flutter is installed and configured
2. Run `flutter pub get` in each app directory
3. Configure Firebase for authentication
4. Set up backend API endpoints

## 📋 Development Status

### ✅ Completed
- [x] User app with shop discovery
- [x] Shop owner app with product management
- [x] Pickup code generation system
- [x] Order confirmation screens
- [x] Clean architecture implementation
- [x] Firebase authentication setup

### 🔄 In Progress
- [ ] Backend API development
- [ ] Real-time order notifications
- [ ] Payment integration at pickup
- [ ] Order history and analytics

### 📅 Planned
- [ ] Advanced search and filtering
- [ ] Shop ratings and reviews
- [ ] Multi-shop orders
- [ ] Loyalty programs

## 🎨 Design System

Each app has its distinct visual identity:
- **User App**: Pink theme, friendly and approachable
- **Shop Owner**: Indigo theme, professional and business-focused

## 🔧 Configuration

### Firebase Setup
- Configure authentication for both apps
- Set up storage for product images
- Enable push notifications for order updates

### API Endpoints
```
/api/shops/           # Shop discovery and management
/api/products/        # Product catalog
/api/orders/          # Order placement and tracking
/api/pickup/          # Pickup code verification
```

This system provides a focused, efficient solution for local marketplace interactions without the complexity of traditional e-commerce platforms.