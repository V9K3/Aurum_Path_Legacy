import 'package:flutter/material.dart';
import 'dart:async';
import 'main_menu_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _progress = 0;
  int _currentStep = 0;
  String _loadingText = 'Initializing...';

  final List<String> _loadingSteps = [
    'Initializing game engine...',
    'Loading market simulation...',
    'Setting up save system...',
    'Preparing user interface...',
    'Loading game assets...',
    'Finalizing setup...',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Simulate loading progress
    _simulateLoading();
  }

  void _simulateLoading() async {
    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _currentStep = i;
          _loadingText = _loadingSteps[i];
          _progress = ((i + 1) * 100 / _loadingSteps.length).round();
        });
      }
    }

    // Navigate to main menu after loading
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainMenuPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/Login_BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24.0 : 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo and Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Currency Icon
                          Container(
                            width: isMobile ? 60 : 80,
                            height: isMobile ? 60 : 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(isMobile ? 30 : 40),
                              border: Border.all(
                                color: const Color(0xFFFFD700),
                                width: isMobile ? 2 : 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(isMobile ? 28 : 38),
                              child: Image.asset(
                                'assets/images/icons/currency.png',
                                width: isMobile ? 40 : 60,
                                height: isMobile ? 40 : 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: isMobile ? 12 : 16),
                          
                          // Aurum Path Text
                          Text(
                            'Aurum Path',
                            style: TextStyle(
                              fontSize: isMobile ? 35 : 45,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFD700),
                              letterSpacing: isMobile ? .8 : 1.2,
                              shadows: const [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      
                      // Legacy Title
                      Text(
                        'Legacy',
                        style: TextStyle(
                          fontSize: isMobile ? 30 : 30,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFD700),
                          letterSpacing: isMobile ? 1 : 1.5,
                          shadows: const [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      // Subtitle
                      Text(
                        'From Seed Capital to Financial Empire',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          color: Colors.white,
                          height: 1.4,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 32 : 40),
                      
                      // Progress Bar
                      Container(
                        width: isMobile ? screenSize.width * 0.8 : 300,
                        height: isMobile ? 6 : 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progress / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                              ),
                              borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      // Progress Text
                      Text(
                        '$_progress%',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: isMobile ? 6 : 8),
                      
                      // Loading Text
                      Text(
                        _loadingText,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 32 : 40),
                      
                      // Loading Tips
                      Container(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '💡 Tip',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: isMobile ? 6 : 8),
                            Text(
                              'Diversify your portfolio across different industries to minimize risk and maximize returns.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 12 : 14,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
} 