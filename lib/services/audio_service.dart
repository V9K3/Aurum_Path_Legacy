import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _backgroundPlayer;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _userInteracted = false;

  // Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _backgroundPlayer = AudioPlayer();
    _isInitialized = true;
  }

  // Start playing background music
  Future<void> playBackgroundMusic() async {
    if (!_isInitialized) await initialize();
    
    if (_isPlaying) {
      print('Background music is already playing');
      return; // Don't restart if already playing
    }
    
    // Check if user has interacted (required for web audio)
    if (!_userInteracted) {
      print('Waiting for user interaction before playing audio...');
      return;
    }
    
    try {
      print('Starting background music...');
      
      // Set volume to maximum
      await _backgroundPlayer?.setVolume(1.0);
      
      // Play the music
      await _backgroundPlayer?.play(AssetSource('music/background/Main_Pg.mp3'));
      _isPlaying = true;
      
      print('Background music started successfully');
      
      // Set up loop
      _backgroundPlayer?.onPlayerComplete.listen((event) {
        print('Music finished, restarting...');
        _isPlaying = false;
        playBackgroundMusic(); // Restart when finished
      });
      
    } catch (e) {
      print('Error playing background music: $e');
      _isPlaying = false;
    }
  }
  
  // Mark that user has interacted (call this on first user interaction)
  void markUserInteracted() {
    if (!_userInteracted) {
      print('User interaction detected, enabling audio...');
      _userInteracted = true;
      // Try to start music if it was waiting
      if (!_isPlaying) {
        playBackgroundMusic();
      }
    }
  }

  // Stop background music
  Future<void> stopBackgroundMusic() async {
    if (!_isInitialized) return;
    
    await _backgroundPlayer?.stop();
    _isPlaying = false;
  }

  // Pause background music
  Future<void> pauseBackgroundMusic() async {
    if (!_isInitialized) return;
    
    await _backgroundPlayer?.pause();
    _isPlaying = false;
  }

  // Resume background music
  Future<void> resumeBackgroundMusic() async {
    if (!_isInitialized) return;
    
    await _backgroundPlayer?.resume();
    _isPlaying = true;
  }

  // Check if music is playing
  bool get isPlaying => _isPlaying;
  
  // Check actual player state
  Future<bool> isActuallyPlaying() async {
    if (!_isInitialized || _backgroundPlayer == null) return false;
    try {
      final state = await _backgroundPlayer!.state;
      return state == PlayerState.playing;
    } catch (e) {
      print('Error checking player state: $e');
      return false;
    }
  }
  
  // Set volume
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) return;
    await _backgroundPlayer?.setVolume(volume);
  }
  
  // Debug info
  Future<void> printDebugInfo() async {
    print('AudioService Debug Info:');
    print('- Initialized: $_isInitialized');
    print('- Is Playing: $_isPlaying');
    print('- Player: ${_backgroundPlayer != null ? 'Created' : 'Null'}');
    
    if (_isInitialized && _backgroundPlayer != null) {
      try {
        final state = await _backgroundPlayer!.state;
        print('- Player State: $state');
      } catch (e) {
        print('- Player State: Error getting state - $e');
      }
    }
  }

  // Dispose resources
  Future<void> dispose() async {
    await _backgroundPlayer?.dispose();
    _backgroundPlayer = null;
    _isInitialized = false;
    _isPlaying = false;
  }
} 