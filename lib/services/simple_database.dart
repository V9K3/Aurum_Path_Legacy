import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleDatabase {
  static final SimpleDatabase _instance = SimpleDatabase._internal();
  factory SimpleDatabase() => _instance;
  SimpleDatabase._internal();

  static SharedPreferences? _prefs;

  Future<void> initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // Save user settings
  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    await initialize();
    await _prefs!.setString('user_settings', jsonEncode(settings));
  }

  // Get user settings
  Future<Map<String, dynamic>?> getUserSettings() async {
    await initialize();
    final settingsString = _prefs!.getString('user_settings');
    if (settingsString != null) {
      return jsonDecode(settingsString) as Map<String, dynamic>;
    }
    return null;
  }

  // Save specific setting
  Future<void> saveSetting(String key, dynamic value) async {
    await initialize();
    final settings = await getUserSettings() ?? {};
    settings[key] = value;
    await saveUserSettings(settings);
  }

  // Get specific setting
  Future<dynamic> getSetting(String key) async {
    await initialize();
    final settings = await getUserSettings();
    return settings?[key];
  }

  // Save game data
  Future<void> saveGameData(String saveName, Map<String, dynamic> gameData) async {
    await initialize();
    final saves = await getGameSaves();
    saves[saveName] = {
      'data': gameData,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _prefs!.setString('game_saves', jsonEncode(saves));
  }

  // Get game saves
  Future<Map<String, dynamic>> getGameSaves() async {
    await initialize();
    final savesString = _prefs!.getString('game_saves');
    if (savesString != null) {
      return jsonDecode(savesString) as Map<String, dynamic>;
    }
    return {};
  }

  // Delete game save
  Future<void> deleteGameSave(String saveName) async {
    await initialize();
    final saves = await getGameSaves();
    saves.remove(saveName);
    await _prefs!.setString('game_saves', jsonEncode(saves));
  }

  // Clear all data
  Future<void> clearAllData() async {
    await initialize();
    await _prefs!.clear();
  }
} 