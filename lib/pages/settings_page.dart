import 'package:flutter/material.dart';
import '../services/simple_user_service.dart';
import '../services/audio_service.dart';
import '../services/avatar_service.dart';
import '../config/avatar_config.dart';
import '../main.dart' show CustomButton;
import '../widgets/sound_button.dart';

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SimpleUserService _userService = SimpleUserService();
  final AudioService _audioService = AudioService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _userSaves = [];
  
  // Character customization
  final TextEditingController _characterNameController = TextEditingController();
  String _selectedAvatar = 'Maverick';

  double _musicVolume = 0.6;
  double _soundVolume = 0.8;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _characterNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() { _isLoading = true; });
    try {
      final saves = await _userService.getUserSaves();
      final characterName = _userService.getSettingValue('characterName') ?? 'DemoPlayer';
      final selectedAvatar = _userService.getSettingValue('selectedAvatar') ?? 'Maverick';
      final musicVolume = _userService.getSettingValue('musicVolume') ?? 0.6;
      final soundVolume = _userService.getSettingValue('soundVolume') ?? 0.8;
      _characterNameController.text = characterName;
      _selectedAvatar = selectedAvatar;
      _musicVolume = musicVolume;
      _soundVolume = soundVolume;
      
      // Apply the loaded volume to the audio service
      await _audioService.setVolume(musicVolume);
      await _audioService.setEffectsVolume(soundVolume);
      print('Settings: Initial volume set to ${(musicVolume * 100).round()}%');
      
      setState(() {
        _userSaves = saves;
        _isLoading = false;
      });
    } catch (e) {
      print('Settings: Error loading user data: $e');
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isSmallMobile = screenSize.width < 400;
    
    return Scaffold(
      body: _isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgrounds/MainBG.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFD700),
                  ),
                ),
              ),
            )
          : isMobile
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgrounds/MainBG.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: _buildContent(isMobile, isSmallMobile),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFFF1F5D8),
                  child: Center(
                    child: Container(
                      width: 600, // Mobile width for consistent image size
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/backgrounds/MainBG.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: _buildContent(isMobile, isSmallMobile),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildContent(bool isMobile, bool isSmallMobile) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => SoundButton.playClickAndRun(() async {
                  Navigator.of(context).pop();
                }),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Section
                _buildSection(
                  'User Information',
                  Icons.person,
                  [
                    _buildInfoRow('Gamer ID', _userService.currentUserId.toString()),
                    _buildInfoRow('Login Status', _userService.isLoggedIn ? 'Logged In' : 'Not Logged In'),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Character Customization Section
                _buildSection(
                  'Character Customization',
                  Icons.person,
                  [
                    _buildCharacterNameRow(),
                    _buildAvatarSelectionRow(),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Settings Section
                _buildSection(
                  'Game Settings',
                  Icons.settings,
                  [
                    _buildSettingRow(
                      'Sound Effects',
                      _userService.isSettingEnabled('sound'),
                      (value) => _userService.updateSetting('soundEnabled', value),
                    ),
                    _buildSettingRow(
                      'Auto Save',
                      _userService.isSettingEnabled('autoSave'),
                      (value) => _userService.updateSetting('autoSaveEnabled', value),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Volume Settings
                _buildSection(
                  'Volume Settings',
                  Icons.volume_up,
                  [
                    _buildSliderRow(
                      'Sound Volume',
                      _soundVolume,
                      (value) async {
                        print('Settings: Sound volume changed to ${(value * 100).round()}%');
                        setState(() { _soundVolume = value; });
                        await _userService.updateSetting('soundVolume', value);
                        await _audioService.setEffectsVolume(value);
                        print('Settings: Effects volume update completed');
                      },
                    ),
                    _buildSliderRow(
                      'Music Volume',
                      _musicVolume,
                      (value) async {
                        print('Settings: Music volume changed to ${(value * 100).round()}%');
                        setState(() { _musicVolume = value; });
                        await _userService.updateSetting('musicVolume', value);
                        await _audioService.setVolume(value);
                        print('Settings: Volume update completed');
                      },
                    ),
                    const SizedBox(height: 12),
                    // Test button for sound effect volume
                    ElevatedButton(
                      onPressed: () => SoundButton.playClickAndRun(() async {
                        // This file must exist and be listed in pubspec.yaml
                        await AudioService().playEffect('music/play/click.mp3');
                      }),
                      child: const Text('Test Sound Effect'),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Save Files Section
                _buildSection(
                  'Save Files (${_userSaves.length})',
                  Icons.save,
                  _userSaves.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No save files found. Start a new game to create saves!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ]
                      : _userSaves.map((save) => _buildSaveFileRow(save)).toList(),
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Back Button
                Center(
                  child: CustomButton(
                    text: 'Back to Menu',
                    icon: Icons.arrow_back,
                    onPressed: () => SoundButton.playClickAndRun(() async {
                      Navigator.of(context).pop();
                    }),
                    isMobile: isMobile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF332d56).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white30.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFFFD700), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD700),
            activeTrackColor: const Color(0xFFFFD700).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD700),
            inactiveColor: Colors.white.withOpacity(0.3),
            min: 0.0,
            max: 1.0,
            divisions: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveFileRow(Map<String, dynamic> save) {
    final saveName = save['save_name'] as String? ?? 'Unknown Save';
    final isAutoSave = save['is_auto_save'] == 1;
    final updatedAt = DateTime.tryParse(save['updated_at'] as String? ?? '') ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAutoSave ? const Color(0xFFFFD700).withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          title: Text(
            saveName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '${isAutoSave ? 'Auto Save' : 'Manual Save'} • ${_formatDate(updatedAt)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _showDeleteSaveDialog(save),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterNameRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Character Name', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _characterNameController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter your character name...',
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (value) {
              _userService.updateSetting('characterName', value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSelectionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Avatar', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          // Calculate number of rows needed
          ...List.generate(
            (AvatarConfig.availableAvatars.length / AvatarConfig.maxAvatarsPerRow).ceil(),
            (rowIndex) {
              final startIndex = rowIndex * AvatarConfig.maxAvatarsPerRow;
              final endIndex = (startIndex + AvatarConfig.maxAvatarsPerRow).clamp(0, AvatarConfig.availableAvatars.length);
              final rowAvatars = AvatarConfig.availableAvatars.sublist(startIndex, endIndex);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowAvatars.map((avatar) {
                    final isSelected = _selectedAvatar == avatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() { _selectedAvatar = avatar; });
                        _userService.updateSetting('selectedAvatar', avatar);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF50562D).withOpacity(0.8) : const Color(0xFF332d56).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF50562D).withOpacity(0.8) : const Color(0xFF332d56).withOpacity(0.9),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AvatarService.getAvatarWidget(avatar, size: 20),
                            const SizedBox(height: 2),
                            Text(
                              avatar.capitalize(), 
                              style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w500)
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }



  Widget _buildActionRow(String label, IconData icon, VoidCallback onPressed, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFFFFD700),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.white70,
            fontSize: 14,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteSaveDialog(Map<String, dynamic> saveData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF332D56),
        title: const Text(
          'Delete Save File',
          style: TextStyle(color: Color(0xFFFFD700)),
        ),
        content: const Text(
          'Are you sure you want to delete this save file? This action cannot be undone.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              _userService.deleteGameSave(saveData['save_name'] as String);
              Navigator.of(context).pop();
              _loadUserData();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF332D56),
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: Color(0xFFFFD700)),
        ),
        content: const Text(
          'This will delete all user data, settings, and save files. This action cannot be undone.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              // This would clear all data - implement as needed
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data cleared successfully'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 