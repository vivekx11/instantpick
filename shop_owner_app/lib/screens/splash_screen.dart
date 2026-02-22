import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';
import '../providers/user_provider.dart';
import '../providers/shop_provider.dart';
import '../services/simple_auth_service.dart';
import 'auth/phone_login_screen.dart';
import 'home/main_screen.dart';
import 'location/shop_location_setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final simpleAuthService = SimpleAuthService();
    
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    try {
      final data = await simpleAuthService.loadSavedAuth();
      
      if (data != null && data['owner'] != null && data['shopId'] != null) {
        // Profile is complete, set user and shop
        userProvider.setUser(data['owner']);
        shopProvider.setShopId(data['shopId']);
        
        // Check if shop has set location
        await _checkShopLocation(data['shopId']);
      } else {
        // No saved data, go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
        );
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
      );
    }
  }

  Future<void> _checkShopLocation(String shopId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLocation = prefs.getBool('shopLocationSet') ?? false;
      
      if (!mounted) return;
      
      if (!hasLocation) {
        // Force shop owner to set location first
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ShopLocationSetupScreen(isFirstTime: true),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // If error, go to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryIndigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkIndigo.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.store,
                size: 60,
                color: AppTheme.primaryIndigo,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Shop Owner Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage Your Business',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
            ),
          ],
        ),
      ),
    );
  }
}