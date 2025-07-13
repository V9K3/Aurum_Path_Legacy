import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    
    // Use different paths for desktop vs mobile
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // For desktop, use a path in the user's documents directory
      final documentsPath = await getDatabasesPath();
      path = join(documentsPath, 'aurum_path_legacy.db');
    } else {
      // For mobile, use the default database path
      path = join(await getDatabasesPath(), 'aurum_path_legacy.db');
    }
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE,
        created_at TEXT NOT NULL,
        last_login TEXT NOT NULL,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // User settings table (JSON storage)
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        settings_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Game saves table
    await db.execute('''
      CREATE TABLE game_saves (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        save_name TEXT NOT NULL,
        game_state_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_auto_save INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Game statistics table
    await db.execute('''
      CREATE TABLE game_statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        stat_name TEXT NOT NULL,
        stat_value REAL NOT NULL,
        stat_type TEXT NOT NULL,
        recorded_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_users_username ON users(username)');
    await db.execute('CREATE INDEX idx_user_settings_user_id ON user_settings(user_id)');
    await db.execute('CREATE INDEX idx_game_saves_user_id ON game_saves(user_id)');
    await db.execute('CREATE INDEX idx_game_statistics_user_id ON game_statistics(user_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add any new tables or modifications here
    }
  }

  // User Management
  Future<int> createUser({
    required String username,
    String? email,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.insert('users', {
      'username': username,
      'email': email,
      'created_at': now,
      'last_login': now,
      'is_active': 1,
    });
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateLastLogin(int userId) async {
    final db = await database;
    await db.update(
      'users',
      {'last_login': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // User Settings Management
  Future<void> saveUserSettings({
    required int userId,
    required Map<String, dynamic> settings,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    // Check if settings already exist for this user
    final existingSettings = await db.query(
      'user_settings',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (existingSettings.isNotEmpty) {
      // Update existing settings
      await db.update(
        'user_settings',
        {
          'settings_json': jsonEncode(settings),
          'updated_at': now,
        },
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } else {
      // Create new settings
      await db.insert('user_settings', {
        'user_id': userId,
        'settings_json': jsonEncode(settings),
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  Future<Map<String, dynamic>?> getUserSettings(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'user_settings',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    
    if (results.isNotEmpty) {
      return jsonDecode(results.first['settings_json'] as String);
    }
    return null;
  }

  // Game Save Management
  Future<int> saveGame({
    required int userId,
    required String saveName,
    required Map<String, dynamic> gameState,
    bool isAutoSave = false,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.insert('game_saves', {
      'user_id': userId,
      'save_name': saveName,
      'game_state_json': jsonEncode(gameState),
      'created_at': now,
      'updated_at': now,
      'is_auto_save': isAutoSave ? 1 : 0,
    });
  }

  Future<void> updateGameSave({
    required int saveId,
    required Map<String, dynamic> gameState,
  }) async {
    final db = await database;
    await db.update(
      'game_saves',
      {
        'game_state_json': jsonEncode(gameState),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [saveId],
    );
  }

  Future<List<Map<String, dynamic>>> getUserSaves(int userId) async {
    final db = await database;
    return await db.query(
      'game_saves',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getGameSave(int saveId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'game_saves',
      where: 'id = ?',
      whereArgs: [saveId],
    );
    
    if (results.isNotEmpty) {
      final save = results.first;
      return {
        ...save,
        'game_state': jsonDecode(save['game_state_json'] as String),
      };
    }
    return null;
  }

  Future<void> deleteGameSave(int saveId) async {
    final db = await database;
    await db.delete(
      'game_saves',
      where: 'id = ?',
      whereArgs: [saveId],
    );
  }

  // Game Statistics Management
  Future<void> recordGameStatistic({
    required int userId,
    required String statName,
    required dynamic statValue,
    required String statType, // 'int', 'double', 'string', 'bool'
  }) async {
    final db = await database;
    await db.insert('game_statistics', {
      'user_id': userId,
      'stat_name': statName,
      'stat_value': statValue.toString(),
      'stat_type': statType,
      'recorded_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getUserStatistics(int userId) async {
    final db = await database;
    return await db.query(
      'game_statistics',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
    );
  }

  // Utility Methods
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('game_statistics');
    await db.delete('game_saves');
    await db.delete('user_settings');
    await db.delete('users');
  }
}

// User Settings Model
class UserSettings {
  final bool soundEnabled;
  final bool musicEnabled;
  final double soundVolume;
  final double musicVolume;
  final String language;
  final bool autoSaveEnabled;
  final int autoSaveInterval; // in minutes
  final String theme;
  final String characterName;
  final String selectedAvatar;
  final Map<String, dynamic> customSettings;

  UserSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.soundVolume = 0.8,
    this.musicVolume = 0.6,
    this.language = 'en',
    this.autoSaveEnabled = true,
    this.autoSaveInterval = 5,
    this.theme = 'default',
    this.characterName = 'DemoPlayer',
    this.selectedAvatar = 'default',
    this.customSettings = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'soundVolume': soundVolume,
      'musicVolume': musicVolume,
      'language': language,
      'autoSaveEnabled': autoSaveEnabled,
      'autoSaveInterval': autoSaveInterval,
      'theme': theme,
      'characterName': characterName,
      'selectedAvatar': selectedAvatar,
      'customSettings': customSettings,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      soundEnabled: json['soundEnabled'] ?? true,
      musicEnabled: json['musicEnabled'] ?? true,
      soundVolume: json['soundVolume']?.toDouble() ?? 0.8,
      musicVolume: json['musicVolume']?.toDouble() ?? 0.6,
      language: json['language'] ?? 'en',
      autoSaveEnabled: json['autoSaveEnabled'] ?? true,
      autoSaveInterval: json['autoSaveInterval'] ?? 5,
      theme: json['theme'] ?? 'default',
      characterName: json['characterName'] ?? 'DemoPlayer',
      selectedAvatar: json['selectedAvatar'] ?? 'default',
      customSettings: json['customSettings'] ?? {},
    );
  }

  UserSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    double? soundVolume,
    double? musicVolume,
    String? language,
    bool? autoSaveEnabled,
    int? autoSaveInterval,
    String? theme,
    String? characterName,
    String? selectedAvatar,
    Map<String, dynamic>? customSettings,
  }) {
    return UserSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      language: language ?? this.language,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      theme: theme ?? this.theme,
      characterName: characterName ?? this.characterName,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

// Game State Model (Basic structure - can be expanded)
class GameState {
  final int playerId;
  final double netWorth;
  final int currentTurn;
  final List<Map<String, dynamic>> companies;
  final Map<String, dynamic> marketData;
  final DateTime gameStartTime;
  final DateTime lastSaveTime;
  final Map<String, dynamic> gameProgress;

  GameState({
    required this.playerId,
    required this.netWorth,
    required this.currentTurn,
    required this.companies,
    required this.marketData,
    required this.gameStartTime,
    required this.lastSaveTime,
    required this.gameProgress,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'netWorth': netWorth,
      'currentTurn': currentTurn,
      'companies': companies,
      'marketData': marketData,
      'gameStartTime': gameStartTime.toIso8601String(),
      'lastSaveTime': lastSaveTime.toIso8601String(),
      'gameProgress': gameProgress,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      playerId: json['playerId'] ?? 0,
      netWorth: json['netWorth']?.toDouble() ?? 0.0,
      currentTurn: json['currentTurn'] ?? 0,
      companies: List<Map<String, dynamic>>.from(json['companies'] ?? []),
      marketData: Map<String, dynamic>.from(json['marketData'] ?? {}),
      gameStartTime: DateTime.parse(json['gameStartTime'] ?? DateTime.now().toIso8601String()),
      lastSaveTime: DateTime.parse(json['lastSaveTime'] ?? DateTime.now().toIso8601String()),
      gameProgress: Map<String, dynamic>.from(json['gameProgress'] ?? {}),
    );
  }
} 