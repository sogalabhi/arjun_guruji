import 'package:arjun_guruji/screens/astottara.dart';
import 'package:arjun_guruji/screens/audio.dart';
import 'package:arjun_guruji/screens/audioplayer.dart';
import 'package:arjun_guruji/screens/books.dart';
import 'package:arjun_guruji/screens/contact.dart';
import 'package:arjun_guruji/screens/contentView.dart';
import 'package:arjun_guruji/screens/gallery.dart';
import 'package:arjun_guruji/screens/home.dart';
import 'package:arjun_guruji/screens/listview.dart';
import 'package:arjun_guruji/screens/lyrics.dart';
import 'package:arjun_guruji/screens/socialMedia.dart';
import 'package:arjun_guruji/screens/splash_screen.dart';
import 'package:arjun_guruji/screens/webview.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), 
      initialRoute: "/",
      routes: {
      "/": (context) => const SplashScreen(),
        "/Home": (context) => const Home(),
        "/Books": (context) => BooksSection(),
        "/Astottara": (context) => AstottaraSection(),
        "/Audio": (context) => const Audio(),
        "/ContentView": (context) => ContentView(),
        "/ListView": (context) => ListViewScreen(),
        "/MusicPLayer": (context) => const AudioPlayerScreen(),
        "/Gallery": (context) => const Gallery(),
        "/Lyrics": (context) => const Lyrics(),
        "/Contact": (context) => SocialMedia(),
        "/Contactpage": (context) => Contact(),
        // "/PdfView": (context) => pdfView(fileurl: '',),
      },
    ),
  );
}
