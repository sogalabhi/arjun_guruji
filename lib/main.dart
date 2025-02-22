import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Screens
import 'package:arjun_guruji/screens/astottara.dart';
import 'package:arjun_guruji/screens/audio.dart';
import 'package:arjun_guruji/screens/audio_player.dart';
import 'package:arjun_guruji/screens/books.dart';
import 'package:arjun_guruji/screens/contact.dart';
import 'package:arjun_guruji/screens/content_view.dart';
import 'package:arjun_guruji/screens/gallery.dart';
import 'package:arjun_guruji/screens/home.dart';
import 'package:arjun_guruji/screens/listview.dart';
import 'package:arjun_guruji/screens/lyrics.dart';
import 'package:arjun_guruji/screens/social_media.dart';
import 'package:arjun_guruji/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case "/Home":
            return MaterialPageRoute(builder: (_) => const Home());
          case "/Books":
            return MaterialPageRoute(builder: (_) => const BooksSection());
          case "/Astottara":
            return MaterialPageRoute(builder: (_) => AstottaraSection());
          case "/Audio":
            return MaterialPageRoute(builder: (_) => const Audio());
          case "/ContentView":
            return MaterialPageRoute(builder: (_) => ContentView());
          case "/ListView":
            return MaterialPageRoute(builder: (_) => ListViewScreen());
          case "/MusicPlayer":
            return MaterialPageRoute(builder: (_) => const AudioPlayerScreen());
          case "/Gallery":
            return MaterialPageRoute(builder: (_) => const Gallery());
          case "/Lyrics":
            return MaterialPageRoute(builder: (_) => const Lyrics());
          case "/Contact":
            return MaterialPageRoute(builder: (_) => const SocialMedia());
          case "/ContactPage":
            return MaterialPageRoute(builder: (_) => Contact());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("404 - Page Not Found")),
              ),
            );
        }
      },
    );
  }
}
