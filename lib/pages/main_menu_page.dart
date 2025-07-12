import 'package:flutter/material.dart';
import 'dart:async';
import 'game_page.dart';
import '../main.dart' show CustomButton;

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock save data for demo
  final Map<String, dynamic> _saveData = {
    'lastSave': DateTime.now().subtract(const Duration(hours: 2)),
    'playerName': 'Demo Player',
    'netWorth': 125000,
    'companies': 3,
    'turn': 45,
  };

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleNewGame() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GamePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _handleContinueGame() {
    // TODO: Load existing save
    _handleNewGame();
  }

  void _handleLoadGame() {
    // TODO: Show save selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Load game feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTutorial() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isSmallMobile = screenSize.width < 400;
    
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
              child: SlideTransition(
                position: _slideAnimation,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 20.0 : 32.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: isMobile ? 20 : 40),
                                      // App Logo and Title
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Currency Icon
                                          Container(
                                            width: isMobile ? 60 : 80,
                                            height: isMobile ? 60 : 80,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF).withOpacity(0.2),
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
                                              fontSize: isMobile ? 30 : 40,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFFD700),
                                              letterSpacing: isMobile ? .8 : 1.2,
                                              shadows: const [
                                                Shadow(
                                                  offset: Offset(2, 2),
                                                  blurRadius: 6,
                                                  color: Colors.black54,
                                                ),
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 3,
                                                  color: Colors.black38,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: isMobile ? 8 : 12),
                                      Text(
                                        'Legacy',
                                        style: TextStyle(
                                          fontSize: isMobile ? (isSmallMobile ? 35 : 35) : 45,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFFD700),
                                          letterSpacing: isMobile ? 1 : 1.5,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 6,
                                              color: Colors.black54,
                                            ),
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 3,
                                              color: Colors.black38,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: isMobile ? 6 : 8),
                                      SizedBox(height: isMobile ? 60 : 60),
                                      // Menu Buttons
                                      CustomButton(
                                        text: 'New Game',
                                        icon: Icons.play_arrow,
                                        onPressed: _handleNewGame,
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 12 : 16),
                                      CustomButton(
                                        text: 'Load',
                                        icon: Icons.folder_open,
                                        onPressed: _handleLoadGame,
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 12 : 16),
                                      CustomButton(
                                        text: 'Tutorial',
                                        icon: Icons.school,
                                        onPressed: _handleTutorial,
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 12 : 16),
                                      CustomButton(
                                        text: 'Settings',
                                        icon: Icons.settings,
                                        onPressed: _handleSettings,
                                        isMobile: isMobile,
                                      ),
                                      // Removed bottom SizedBox
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Footer
                          Padding(
                            padding: EdgeInsets.only(top: isMobile ? 16 : 32, bottom: isMobile ? 8 : 16),
                            child: Text(
                              '© 2024 Aurum Path - Learn Business & Economics Through Play',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 11 : 13,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFFD700),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 