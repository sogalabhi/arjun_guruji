import 'package:arjun_guruji/customwidgets/card_homepage.dart';
import 'package:arjun_guruji/utils/models.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    List<Items> myList = [];
    myList.add(Items("Books", "Books", 'assets/mainbook.png', 'txt'));
    myList.add(
        Items("Astottara", "Astottara", 'assets/mainastottaras.png', 'txt'));
    myList.add(Items("Audio", "Audio", 'assets/mainaudio.png', 'txt'));
    myList.add(Items("Lyrics", "Lyrics", 'assets/mainlyrics.png', 'txt'));
    myList.add(Items("Gallery", "Gallery", 'assets/maingallery.png', 'txt'));
    myList.add(Items("Contact", "Contact", 'assets/mainlinks.png', 'txt'));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 1, 0, 54),
              Color.fromARGB(255, 51, 47, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "Arjun Guruji",
                style: TextStyle(
                  fontFamily: 'samarkan',
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/mainimg.png",
              height: height/3.4,
              width: width/1.4,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardHome(pagename: myList[0], width: width, height: height),
                CardHome(pagename: myList[1], width: width, height: height),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardHome(pagename: myList[2], width: width, height: height),
                CardHome(pagename: myList[3], width: width, height: height),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardHome(pagename: myList[4], width: width, height: height),
                CardHome(pagename: myList[5], width: width, height: height),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
