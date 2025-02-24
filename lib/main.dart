import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/presentation/pages/all_astottara_page.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/all_books_page.dart';
import 'package:arjun_guruji/features/Home/presentation/pages/home_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Screens
import 'package:arjun_guruji/screens/audio_player.dart';
import 'package:arjun_guruji/screens/contact.dart';
import 'package:arjun_guruji/screens/content_view.dart';
import 'package:arjun_guruji/screens/gallery.dart';
import 'package:arjun_guruji/screens/listview.dart';
import 'package:arjun_guruji/screens/social_media.dart';
import 'package:arjun_guruji/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //hive
  await Hive.initFlutter();
  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(AstottaraModelAdapter());

  setupLocator();
  // Initialize Firebase (only if you're using Firebase)
  await Firebase.initializeApp();

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
        fontFamily: 'poppins',
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case "/Home":
            return MaterialPageRoute(builder: (_) => const HomePage());
          case "/Books":
            return MaterialPageRoute(builder: (_) => const AllBooksPage());
          case "/Astottara":
            return MaterialPageRoute(builder: (_) => const AllAstottaraPage());
          case "/ContentView":
            return MaterialPageRoute(builder: (_) => const ContentView());
          case "/ListView":
            return MaterialPageRoute(builder: (_) => const ListViewScreen());
          case "/MusicPlayer":
            return MaterialPageRoute(builder: (_) => const AudioPlayerScreen());
          case "/Gallery":
            return MaterialPageRoute(builder: (_) => const Gallery());
          case "/Contact":
            return MaterialPageRoute(builder: (_) => const SocialMedia());
          case "/ContactPage":
            return MaterialPageRoute(builder: (_) => const Contact());
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
