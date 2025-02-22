import 'package:arjun_guruji/screens/pdf_view.dart';
import 'package:arjun_guruji/utils/models.dart';
import 'package:flutter/material.dart';

class GridLayout extends StatefulWidget {
  final String name;
  const GridLayout(this.name, {super.key});

  @override
  GridLayoutState createState() => GridLayoutState();
}

class GridLayoutState extends State<GridLayout> {
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [];
    double _ratio = 1;
    double _width = 60;
    Color _color = Colors.yellow;
    if (widget.name == "Home") {
      myList.add(Items("Books", "Books", 'assets/mainbook.png', 'txt'));
      myList.add(
          Items("Astottara", "Astottara", 'assets/mainastottaras.png', 'txt'));
      myList.add(Items("Audio", "Audio", 'assets/mainaudio.png', 'txt'));
      myList.add(Items("Lyrics", "Lyrics", 'assets/mainlyrics.png', 'txt'));
      myList.add(Items("Gallery", "Gallery", 'assets/maingallery.png', 'txt'));
      myList.add(Items("Contact", "Contact", 'assets/mainlinks.png', 'txt'));
    } else if (widget.name == "Audio") {
      myList.add(Items("ಆರತಿ", "Arati", 'assets/mainaudio.png', 'txt'));
      myList.add(Items(
          "ಭಜ ಗುರುನಾಥಮ್", "BhajaGurunatham", 'assets/mainaudio.png', 'txt'));
      myList
          .add(Items("ಅಷ್ಟೋತ್ತರ", "Astottara", 'assets/mainaudio.png', 'txt'));
      myList.add(Items(
          "ಭುವನದ ಭಾಗ್ಯ", "BhuvanadaBhagya", 'assets/mainaudio.png', 'txt'));
    } else if (widget.name == "Lyrics") {
      myList.add(Items(
          "ನಿತ್ಯ ಭಜನೆಗಳು", "Daily bhajans", 'assets/mainlyrics.png', 'txt'));
      myList.add(Items("ಆರತಿ", "Arti", 'assets/mainlyrics.png', 'txt'));
      myList.add(Items("ಇತರೆ", "Others", 'assets/mainlyrics.png', 'txt'));
    } else if (widget.name == "Books") {
      _color = Colors.white;
      _width = 120;
      _ratio = 0.7;
      myList.add(
          Items("ಗುರುದಾರಿ", "ಗುರುದಾರಿ", 'assets/bookgurudaari.png', 'txt'));
      myList.add(Items("ವೇಂಕಟಾರ್ಜುನ ವಿಜಯಂ", "vv", 'assets/bookvv.png', 'txt'));
      myList.add(Items("ಗಾನ ವಿಜಯರ್ಜುನ", "Gaanavijayarjuna",
          'assets/bookgaanavijayarjuna.png', 'txt'));
      myList.add(Items("ಗುರುದೇವೋ ಭವ", "Gurudevo Bhava",
          'assets/bookgurudevobhava.png', 'txt'));
      myList.add(Items("ಭಕ್ತಿ ಕುಸುಮಾಂಜಲಿ", "Bhakti Kusumanjali",
          'assets/bookbhaktikusumanjali.png', 'txt'));
      myList.add(Items("ದಿನಕ್ಕೊಂದು ಶ್ಲೋಕ", "Dinakkondu shloka",
          'assets/bookdinakkondushloka.png', 'txt'));
      myList.add(Items("ಅರ್ಜುನಂ ಭಜೇ", "Arjunam Bhaje",
          'assets/bookarjunambhaje.png', 'txt'));
      myList.add(Items("ಅರ್ಜುನಾಮೃತಧಾರೆ", "arjunamruthadhare",
          'assets/arjunaamruthadhaare.jpg', 'pdf'));
      myList.add(Items(
          "ಅವಧೂತ ರತ್ನ", "avadhutaratna", 'assets/avadhutaratna.jpg', 'pdf'));
      myList.add(Items("ಅನುಭಾವ", "anubhava", 'assets/anubhava.jpg', 'pdf'));
      myList.add(Items("ಗುರುಚರಿತ್ರೆ", "gc_kan", 'assets/anubhava.jpg', 'pdf'));
      myList
          .add(Items("Guru Charitre", "gc_eng", 'assets/anubhava.jpg', 'pdf'));
    } else if (widget.name == "Astottara") {
      _width = 120;
      _ratio = 0.7;
      _color = Colors.white;
      myList.add(
          Items("ಶ್ರೀ ಗುರುನಾಥರ ಅಷ್ಟೋತ್ತರ", "ast1", 'assets/ast1.png', 'txt'));
      myList.add(
          Items("ಅರ್ಜುನ ಗುರುಗಳ ಅಷ್ಟೋತ್ತರ", "ast2", 'assets/ast2.png', 'txt'));
      myList.add(Items(
          "ಶ್ರೀ ಶ್ರೀಧರ ಸ್ವಾಮಿಗಳ ಅಷ್ಟೋತ್ತರ", "ast3", 'assets/ast3.png', 'txt'));
      myList.add(Items("ಶ್ರೀ ಶ್ರೀ ಶ್ರೀ ಚಂದ್ರಶೇಖರ ಭಾರತೀ ಮಹಾಸ್ವಾಮಿಗಳ ಅಷ್ಟೋತ್ತರ",
          "ast4", 'assets/ast4.png', 'txt'));
      myList
          .add(Items("ದತ್ತಾತ್ರೆಯ ಅಷ್ಟೋತ್ತರ", "ast5", 'assets/ast5.png', 'txt'));
      myList
          .add(Items("ಸಾಯಿ ಬಾಬಾ ಅಷ್ಟೋತ್ತರ", "ast6", 'assets/ast6.png', 'txt'));
    }

    return Flexible(
      child: GridView.count(
          childAspectRatio: _ratio,
          crossAxisCount: 2,
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: myList.map((data) {
            return InkWell(
              onTap: () {
                if (widget.name == "Home") {
                  Navigator.pushNamed(context, "/${data.title}");
                } else if (data.title == "ಗುರುದಾರಿ" ||
                    widget.name == "Audio" ||
                    widget.name == "Lyrics") {
                  Navigator.pushNamed(context, '/ListView', arguments: {
                    'name': data.title,
                    'filename': data.url,
                  });
                } else if (widget.name == "Books" ||
                    widget.name == "Astottara") {
                  if (data.type == 'txt') {
                    Navigator.pushNamed(context, '/ContentView', arguments: {
                      'name': data.title,
                      'filename': data.url,
                    });
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PdfView(
                              fileurl: 'raw/${data.url}.pdf',
                              name: data.title,
                            )));

                    // Navigator.pushNamed(context, '/PdfView', arguments: {
                    //   'name': data.title,
                    //   'filename': 'raw/'+data.url+'.pdf',
                    // });
                  }
                }
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                decoration: BoxDecoration(
                    color: _color, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Builder(builder: (context) {
                      if (_width == 60) {
                        return Image.asset(
                          data.img,
                          width: _width,
                        );
                      } else {
                        return Image.asset(
                          data.img,
                        );
                      }
                    }),
                    Text(data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}
