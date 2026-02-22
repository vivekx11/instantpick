import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/google_auth_service.dart';
import 'auth/google_login_screen.dart';
import 'home/main_screen.dart';
import 'location/user_location_setup_screen.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final googleAuthService = GoogleAuthService();
    
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    try {
      final user = await googleAuthService.loadSavedUser();
      
      if (user != null) {
        authProvider.setUser(user);
        
        // Check if user has set location
        await _checkUserLocation(user.id);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
        );
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
      );
    }
  }

  Future<void> _checkUserLocation(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLocation = prefs.getBool('userLocationSet') ?? false;
      
      if (!mounted) return;
      
      if (!hasLocation) {
        // Force user to set location first
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserLocationSetupScreen(isFirstTime: true),
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
      backgroundColor: AppTheme.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/95a5f784-9642-498c-8f9f-4318d1f2b1c4/G2In3j3V3Y.json',
              width: 280,
              height: 280,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.softPink,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 60,
                  color: AppTheme.primaryPink,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Local Marketplace',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPink,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Shop Local, Shop Easy',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
