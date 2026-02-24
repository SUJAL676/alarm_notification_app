// import 'package:audio_session/audio_session.dart';
// import 'package:just_audio/just_audio.dart';
//
// class AlarmService {
//   static final AudioPlayer _player = AudioPlayer();
//   static bool _isPlaying = false;
//
//   // static Future<void> startAlarm() async
//   // {
//   //   try{
//   //     if (_isPlaying) return;
//   //
//   //     await _player.setAsset('assets/sounds/set.mp3');
//   //     _player.setLoopMode(LoopMode.one);
//   //     await _player.play();
//   //
//   //     _isPlaying = true;
//   //     print(" Alarm started");
//   //   }
//   //   catch(err)
//   //   {
//   //     print("errror : ${err.toString()}");
//   //   }
//   // }
//
//   static Future<void> startAlarm() async {
//     try {
//       final session = await AudioSession.instance;
//       await session.configure(const AudioSessionConfiguration.music());
//
//       await _player.setAsset("assets/sounds/set.mp3");
//       await _player.setLoopMode(LoopMode.one);
//       await _player.play();
//
//       _isPlaying = true;
//       print(" Alarm started");
//     } catch (err) {
//       print("error: ${err.toString()}");
//     }
//   }
//
//   static Future<void> stopAlarm() async {
//     if (!_isPlaying) return;
//
//     await _player.stop();
//     _isPlaying = false;
//     print(" Alarm stopped");
//   }
// }