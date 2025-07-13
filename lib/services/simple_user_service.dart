import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'simple_database.dart';

class SimpleUserService extends ChangeNotifier {
  static final SimpleUserService _instance = SimpleUserService._internal();
  factory SimpleUserService() => _instance;
  SimpleUserService._internal();

  final SimpleDatabase _database = SimpleDatabase();
  bool _isInitialized = false;

  // Current user data
  Map<String, dynamic> _currentSettings = {
    'characterName': 'DemoPlayer',
    'selectedAvatar': 'Maverick',
    'soundEnabled': true,
    'musicEnabled': true,
    'soundVolume': 0.8,
    'musicVolume': 0.6,
    'autoSaveEnabled': true,
    'autoSaveInterval': 5,
    'language': 'en',
    'theme': 'default',
  };

  // Getters
  bool get isInitialized => _isInitialized;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _database.initialize();
      
      // Load saved settings
      final savedSettings = await _database.getUserSettings();
      if (savedSettings != null) {
        _currentSettings.addAll(savedSettings);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing SimpleUserService: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Get setting value
  dynamic getSettingValue(String settingName) {
    return _currentSettings[settingName];
  }

  // Update setting
  Future<void> updateSetting(String settingName, dynamic value) async {
    _currentSettings[settingName] = value;
    notifyListeners();
    
    try {
      await _database.saveSetting(settingName, value);
    } catch (e) {
      debugPrint('Error saving setting $settingName: $e');
    }
  }

  // Get character name
  String get characterName => _currentSettings['characterName'] ?? 'DemoPlayer';

  // Get selected avatar
  String get selectedAvatar => _currentSettings['selectedAvatar'] ?? 'Maverick';

  // Get music volume
  double get musicVolume => _currentSettings['musicVolume']?.toDouble() ?? 0.6;

  // Get sound volume
  double get soundVolume => _currentSettings['soundVolume']?.toDouble() ?? 0.8;

  // Get current username
  String get currentUsername => _currentSettings['characterName'] ?? 'DemoPlayer';

  // Get current user ID (always 1 for simple service)
  int get currentUserId => 1;

  // Check if logged in (always true for simple service)
  bool get isLoggedIn => true;

  // Check if setting is enabled
  bool isSettingEnabled(String settingName) {
    switch (settingName) {
      case 'sound':
        return _currentSettings['soundEnabled'] ?? true;
      case 'music':
        return _currentSettings['musicEnabled'] ?? true;
      case 'autoSave':
        return _currentSettings['autoSaveEnabled'] ?? true;
      default:
        return true;
    }
  }

  // Save game
  Future<void> saveGame({
    required String saveName,
    required Map<String, dynamic> gameState,
    bool isAutoSave = false,
  }) async {
    try {
      final gameData = {
        'gameState': gameState,
        'isAutoSave': isAutoSave,
        'saveName': saveName,
      };
      await _database.saveGameData(saveName, gameData);
    } catch (e) {
      debugPrint('Error saving game: $e');
    }
  }

  // Get user saves
  Future<List<Map<String, dynamic>>> getUserSaves() async {
    try {
      final saves = await _database.getGameSaves();
      return saves.entries.map((entry) => {
        'id': entry.key,
        'save_name': entry.key,
        'game_state_json': jsonEncode(entry.value['data']),
        'created_at': entry.value['timestamp'],
        'updated_at': entry.value['timestamp'],
        'is_auto_save': entry.value['data']['isAutoSave'] ?? false,
      }).toList();
    } catch (e) {
      debugPrint('Error loading user saves: $e');
      return [];
    }
  }

  // Delete game save
  Future<void> deleteGameSave(String saveName) async {
    try {
      await _database.deleteGameSave(saveName);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting game save: $e');
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _database.clearAllData();
      _currentSettings = {
        'characterName': 'DemoPlayer',
        'selectedAvatar': 'Maverick',
        'soundEnabled': true,
        'musicEnabled': true,
        'soundVolume': 0.8,
        'musicVolume': 0.6,
        'autoSaveEnabled': true,
        'autoSaveInterval': 5,
        'language': 'en',
        'theme': 'default',
      };
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }
} 