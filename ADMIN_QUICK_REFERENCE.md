# 🚀 Admin App - Quick Reference Card

## 📋 Setup Checklist

- [ ] Backend mein `ADMIN_KEY` set kiya `.env` mein
- [ ] Backend running hai (`npm start`)
- [ ] Admin app dependencies installed (`flutter pub get`)
- [ ] API URL correct hai `api_constants.dart` mein
- [ ] Admin key yaad hai login ke liye

## 🔑 Login Credentials

```
Admin Key: (Check backend/.env file)
Location: ADMIN_KEY=your_key_here
```

## 🎯 Quick Actions

| Action | Steps |
|--------|-------|
| **Block User** | Dashboard → Users → Expand → Block |
| **Delete User** | Dashboard → Users → Expand → Delete |
| **Deactivate Shop** | Dashboard → Shops → Expand → Deactivate |
| **Delete Shop** | Dashboard → Shops → Expand → Delete |
| **Delete Product** | Dashboard → Products → Expand → Delete |
| **Update Order** | Dashboard → Orders → Expand → Change Status |
| **View Logs** | Dashboard → System Logs |
| **Refresh Data** | Pull down or click refresh icon |
| **Logout** | Click logout icon in AppBar |

## 📊 Dashboard Stats

| Stat | Description |
|------|-------------|
| Total Users | Sabhi registered users |
| Total Shops | Sabhi shops (active + inactive) |
| Total Products | Sabhi products |
| Total Orders | Sabhi orders (all status) |
| Active Shops | Currently active shops |
| Pending Orders | Orders waiting for action |

## 🔄 Order Status Flow

```
pending → confirmed → ready → completed
   ↓
cancelled (anytime)
```

## 🎨 Status Colors

| Status | Color | Meaning |
|--------|-------|---------|
| 🟢 Green | Active/Completed | Good |
| 🟠 Orange | Pending/Warning | Attention needed |
| 🔴 Red | Inactive/Cancelled | Problem |
| 🟣 Purple | Processing | In progress |

## 🛠️ Common Commands

### Start Backend
```bash
cd backend
npm start
```

### Start Admin App
```bash
cd admin_app
flutter run
```

### Test API
```bash
node test_admin_api.js
```

### Quick Start (Windows)
```bash
start_admin.bat
```

## 📱 Screen Navigation

```
Login Screen
    ↓
Dashboard
    ├─→ Users Screen
    ├─→ Shops Screen
    ├─→ Products Screen
    ├─→ Orders Screen
    └─→ Logs Screen
```

## 🔒 Security Tips

✅ Admin key ko secret rakho
✅ Strong password use karo
✅ Regular logout karo
✅ Suspicious activity monitor karo
✅ Backup regularly lo

## ⚠️ Important Warnings

🚨 **Delete operations permanent hain**
🚨 **Shop delete = All products delete**
🚨 **User delete = All data lost**
🚨 **Always confirm before delete**

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Can't login | Check admin key in `.env` |
| No data showing | Check backend is running |
| Connection error | Check API URL in code |
| 403 error | Admin key mismatch |
| 500 error | Check backend logs |

## 📞 API Endpoints Quick Reference

```
GET    /api/admin/stats                      Dashboard
GET    /api/admin/users                      Users list
PATCH  /api/admin/users/:id/toggle-status    Block/Unblock
DELETE /api/admin/users/:id                  Delete user
GET    /api/admin/shops                      Shops list
PATCH  /api/admin/shops/:id/toggle-status    Activate/Deactivate
DELETE /api/admin/shops/:id                  Delete shop
GET    /api/admin/products                   Products list
DELETE /api/admin/products/:id               Delete product
GET    /api/admin/orders                     Orders list
PATCH  /api/admin/orders/:id/status          Update status
GET    /api/admin/logs                       System logs
```

## 🎯 Best Practices

1. **Regular Monitoring**
   - Dashboard daily check karo
   - Pending orders quickly handle karo
   - Suspicious users ko block karo

2. **Data Management**
   - Inactive shops ko deactivate karo
   - Old products ko remove karo
   - Completed orders ko archive karo

3. **Security**
   - Admin key change karo regularly
   - Logout after use
   - Monitor system logs

4. **Performance**
   - Pull to refresh for latest data
   - Don't keep app open unnecessarily
   - Clear cache if slow

## 📈 Metrics to Monitor

- Daily new users
- Active shops ratio
- Order completion rate
- Average order value
- Response time to orders

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| `backend/.env` | Admin key & secrets |
| `admin_app/lib/core/constants/api_constants.dart` | API URLs |
| `admin_app/pubspec.yaml` | Dependencies |

## 📚 Documentation Files

| File | Content |
|------|---------|
| `ADMIN_APP_GUIDE.md` | Hindi usage guide |
| `ADMIN_APP_COMPLETE.md` | Complete documentation |
| `ADMIN_APP_ARCHITECTURE.md` | Technical architecture |
| `ADMIN_APP_SUMMARY.md` | Quick summary |
| `admin_app/README.md` | Technical reference |

## 🎊 Quick Tips

💡 Use pull-to-refresh for latest data
💡 Expansion tiles for detailed view
💡 Confirmation dialogs prevent mistakes
💡 Color coding for quick status check
💡 Logout when done for security

## 📞 Support

For issues:
1. Check troubleshooting section
2. Review backend logs
3. Check API responses
4. Verify admin key

---

**Remember:** With great power comes great responsibility! 🦸‍♂️
