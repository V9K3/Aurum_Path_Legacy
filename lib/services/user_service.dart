import 'package:flutter/foundation.dart';
import 'database_service.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // Current user data
  Map<String, dynamic>? _currentUser;
  UserSettings? _currentUserSettings;
  bool _isInitialized = false;

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  UserSettings? get currentUserSettings => _currentUserSettings;
  bool get isLoggedIn => _currentUser != null;
  bool get isInitialized => _isInitialized;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // For now, create a default user if none exists
      // In a real app, you'd check for existing sessions
      await _createDefaultUserIfNeeded();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing UserService: $e');
      // Create fallback user data if database fails
      _createFallbackUser();
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Create a default user for demo purposes
  Future<void> _createDefaultUserIfNeeded() async {
    // Check if any users exist
    final existingUser = await _databaseService.getUserByUsername('DemoPlayer');
    
    if (existingUser == null) {
      // Create default user
      final userId = await _databaseService.createUser(
        username: 'DemoPlayer',
        email: 'demo@aurumpath.com',
      );
      
      // Create default settings
      final defaultSettings = UserSettings();
      await _databaseService.saveUserSettings(
        userId: userId,
        settings: defaultSettings.toJson(),
      );
      
      // Set as current user
      _currentUser = await _databaseService.getUserByUsername('DemoPlayer');
      _currentUserSettings = defaultSettings;
    } else {
      // Use existing user
      _currentUser = existingUser;
      final settingsData = await _databaseService.getUserSettings(existingUser['id'] as int);
      _currentUserSettings = settingsData != null 
          ? UserSettings.fromJson(settingsData)
          : UserSettings();
    }
  }

  // Create fallback user when database fails
  void _createFallbackUser() {
    _currentUser = {
      'id': 1,
      'username': 'DemoPlayer',
      'email': 'demo@aurumpath.com',
      'created_at': DateTime.now().toIso8601String(),
      'last_login': DateTime.now().toIso8601String(),
      'is_active': 1,
    };
    _currentUserSettings = UserSettings();
  }

  // Login user
  Future<bool> loginUser(String username) async {
    try {
      final user = await _databaseService.getUserByUsername(username);
      if (user != null) {
        _currentUser = user;
        await _databaseService.updateLastLogin(user['id'] as int);
        
        // Load user settings
        final settingsData = await _databaseService.getUserSettings(user['id'] as int);
        _currentUserSettings = settingsData != null 
            ? UserSettings.fromJson(settingsData)
            : UserSettings();
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error logging in user: $e');
      return false;
    }
  }

  // Create new user
  Future<bool> createUser(String username, {String? email}) async {
    try {
      final userId = await _databaseService.createUser(
        username: username,
        email: email,
      );
      
      // Create default settings for new user
      final defaultSettings = UserSettings();
      await _databaseService.saveUserSettings(
        userId: userId,
        settings: defaultSettings.toJson(),
      );
      
      // Login the new user
      return await loginUser(username);
    } catch (e) {
      debugPrint('Error creating user: $e');
      return false;
    }
  }

  // Update user settings
  Future<void> updateUserSettings(UserSettings newSettings) async {
    if (_currentUser == null) return;
    
    try {
      await _databaseService.saveUserSettings(
        userId: _currentUser!['id'] as int,
        settings: newSettings.toJson(),
      );
      
      _currentUserSettings = newSettings;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user settings: $e');
      // Update local settings even if database fails
      _currentUserSettings = newSettings;
      notifyListeners();
    }
  }

  // Save game
  Future<int?> saveGame({
    required String saveName,
    required Map<String, dynamic> gameState,
    bool isAutoSave = false,
  }) async {
    if (_currentUser == null) return null;
    
    try {
      return await _databaseService.saveGame(
        userId: _currentUser!['id'] as int,
        saveName: saveName,
        gameState: gameState,
        isAutoSave: isAutoSave,
      );
    } catch (e) {
      debugPrint('Error saving game: $e');
      return null;
    }
  }

  // Load user saves
  Future<List<Map<String, dynamic>>> getUserSaves() async {
    if (_currentUser == null) return [];
    
    try {
      return await _databaseService.getUserSaves(_currentUser!['id'] as int);
    } catch (e) {
      debugPrint('Error loading user saves: $e');
      return [];
    }
  }

  // Load specific game save
  Future<Map<String, dynamic>?> loadGameSave(int saveId) async {
    try {
      return await _databaseService.getGameSave(saveId);
    } catch (e) {
      debugPrint('Error loading game save: $e');
      return null;
    }
  }

  // Delete game save
  Future<void> deleteGameSave(int saveId) async {
    try {
      await _databaseService.deleteGameSave(saveId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting game save: $e');
    }
  }

  // Record game statistic
  Future<void> recordGameStatistic({
    required String statName,
    required dynamic statValue,
    required String statType,
  }) async {
    if (_currentUser == null) return;
    
    try {
      await _databaseService.recordGameStatistic(
        userId: _currentUser!['id'] as int,
        statName: statName,
        statValue: statValue,
        statType: statType,
      );
    } catch (e) {
      debugPrint('Error recording game statistic: $e');
    }
  }

  // Get user statistics
  Future<List<Map<String, dynamic>>> getUserStatistics() async {
    if (_currentUser == null) return [];
    
    try {
      return await _databaseService.getUserStatistics(_currentUser!['id'] as int);
    } catch (e) {
      debugPrint('Error loading user statistics: $e');
      return [];
    }
  }

  // Logout user
  void logout() {
    _currentUser = null;
    _currentUserSettings = null;
    notifyListeners();
  }

  // Get current user ID
  int? get currentUserId => _currentUser?['id'] as int?;

  // Get current username
  String? get currentUsername => _currentUser?['username'] as String?;

  // Check if setting is enabled
  bool isSettingEnabled(String settingName) {
    if (_currentUserSettings == null) return true; // Default to enabled
    
    switch (settingName) {
      case 'sound':
        return _currentUserSettings!.soundEnabled;
      case 'music':
        return _currentUserSettings!.musicEnabled;
      case 'autoSave':
        return _currentUserSettings!.autoSaveEnabled;
      default:
        return true;
    }
  }

  // Get setting value
  dynamic getSettingValue(String settingName) {
    if (_currentUserSettings == null) return null;
    
    switch (settingName) {
      case 'soundVolume':
        return _currentUserSettings!.soundVolume;
      case 'musicVolume':
        return _currentUserSettings!.musicVolume;
      case 'language':
        return _currentUserSettings!.language;
      case 'autoSaveInterval':
        return _currentUserSettings!.autoSaveInterval;
      case 'theme':
        return _currentUserSettings!.theme;
      case 'characterName':
        return _currentUserSettings!.characterName;
      case 'selectedAvatar':
        return _currentUserSettings!.selectedAvatar;
      default:
        return _currentUserSettings!.customSettings[settingName];
    }
  }

  // Update specific setting
  Future<void> updateSetting(String settingName, dynamic value) async {
    if (_currentUserSettings == null) return;
    
    UserSettings newSettings;
    
    switch (settingName) {
      case 'soundEnabled':
        newSettings = _currentUserSettings!.copyWith(soundEnabled: value as bool);
        break;
      case 'musicEnabled':
        newSettings = _currentUserSettings!.copyWith(musicEnabled: value as bool);
        break;
      case 'soundVolume':
        newSettings = _currentUserSettings!.copyWith(soundVolume: value as double);
        break;
      case 'musicVolume':
        newSettings = _currentUserSettings!.copyWith(musicVolume: value as double);
        break;
      case 'language':
        newSettings = _currentUserSettings!.copyWith(language: value as String);
        break;
      case 'autoSaveEnabled':
        newSettings = _currentUserSettings!.copyWith(autoSaveEnabled: value as bool);
        break;
      case 'autoSaveInterval':
        newSettings = _currentUserSettings!.copyWith(autoSaveInterval: value as int);
        break;
      case 'theme':
        newSettings = _currentUserSettings!.copyWith(theme: value as String);
        break;
      case 'characterName':
        newSettings = _currentUserSettings!.copyWith(characterName: value as String);
        break;
      case 'selectedAvatar':
        newSettings = _currentUserSettings!.copyWith(selectedAvatar: value as String);
        break;
      default:
        // Handle custom settings
        final customSettings = Map<String, dynamic>.from(_currentUserSettings!.customSettings);
        customSettings[settingName] = value;
        newSettings = _currentUserSettings!.copyWith(customSettings: customSettings);
        break;
    }
    
    try {
      await updateUserSettings(newSettings);
    } catch (e) {
      debugPrint('Error updating setting $settingName: $e');
      // Update local settings even if database fails
      _currentUserSettings = newSettings;
      notifyListeners();
    }
  }


} 