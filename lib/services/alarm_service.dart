import 'package:just_audio/just_audio.dart';

class AlarmService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> startAlarm() async {
    try {
      if (_player.playing) {
        print("Already playing");
        return;
      }

      await _player.setAsset('assets/sounds/set.mp3');
      await _player.setLoopMode(LoopMode.one);
      await _player.play();

      print("Alarm started");
    } catch (e) {
      print("Start alarm error: $e");
    }
  }

  static Future<void> stopAlarm() async {
    try {
      if (!_player.playing) {
        print("Alarm already stopped");
        return;
      }

      await _player.stop();
      await _player.seek(Duration.zero);

      print("Alarm stopped");
    } catch (e) {
      print("Stop alarm error: $e");
    }
  }
}
