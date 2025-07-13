import '../services/audio_service.dart';

class SoundButton {
  static Future<void> playClickAndRun(Future<void> Function() action) async {
    await AudioService().playEffect('music/play/click.mp3');
    await action();
  }
} 