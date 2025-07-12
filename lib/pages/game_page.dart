import 'package:flutter/material.dart';
import '../main.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _turn = 1;
  double _cash = 50000;
  double _netWorth = 50000;
  int _companies = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isSmallMobile = screenSize.width < 400;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: const Color(0xFFFFD700),
                  size: isMobile ? 16 : 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aurum Path',
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 18 : 20,
                  ),
                ),
              ],
            ),
            Text(
              'Legacy',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save, 
              color: Colors.white,
              size: isMobile ? 20 : 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Game saved!'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(isMobile ? 16 : 8),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.menu, 
              color: Colors.white,
              size: isMobile ? 20 : 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/Login_BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
              child: Column(
                children: [
                  // Game Stats Header
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: isMobile 
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    'Turn',
                                    _turn.toString(),
                                    Icons.schedule,
                                    isMobile: isMobile,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Cash',
                                    '\$${_cash.toStringAsFixed(0)}',
                                    Icons.attach_money,
                                    isMobile: isMobile,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    'Net Worth',
                                    '\$${_netWorth.toStringAsFixed(0)}',
                                    Icons.trending_up,
                                    isMobile: isMobile,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Companies',
                                    _companies.toString(),
                                    Icons.business,
                                    isMobile: isMobile,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                'Turn',
                                _turn.toString(),
                                Icons.schedule,
                                isMobile: isMobile,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Cash',
                                '\$${_cash.toStringAsFixed(0)}',
                                Icons.attach_money,
                                isMobile: isMobile,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Net Worth',
                                '\$${_netWorth.toStringAsFixed(0)}',
                                Icons.trending_up,
                                isMobile: isMobile,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Companies',
                                _companies.toString(),
                                Icons.business,
                                isMobile: isMobile,
                              ),
                            ),
                          ],
                        ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  
                  // Game Content
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isMobile ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.construction,
                            size: isMobile ? 60 : 80,
                            color: const Color(0xFFFFD700),
                          ),
                          SizedBox(height: isMobile ? 16 : 24),
                          Text(
                            'Game Interface Coming Soon!',
                            style: TextStyle(
                              fontSize: isMobile ? (isSmallMobile ? 18 : 20) : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isMobile ? 12 : 16),
                          Text(
                            'This is where the Financial Empire Game will be implemented with:\n\n• Company management\n• Market simulation\n• Investment strategies\n• Economic cycles\n• And much more!',
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isMobile ? 24 : 32),
                          SizedBox(
                            width: isMobile ? double.infinity : null,
                            child: CustomButton(
                              text: 'Next Turn',
                              onPressed: () {
                                setState(() {
                                  _turn++;
                                  _cash += 1000;
                                  _netWorth += 1000;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Turn advanced!'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(isMobile ? 16 : 8),
                                  ),
                                );
                              },
                              isMobile: isMobile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {bool isMobile = false}) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFFFD700),
          size: isMobile ? 20 : 24,
        ),
        SizedBox(height: isMobile ? 6 : 8),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 10 : 12,
          ),
        ),
      ],
    );
  }
} 