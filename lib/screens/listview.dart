import 'package:arjun_guruji/customwidgets/heading.dart';
import 'package:flutter/material.dart';
class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  ListViewScreenState createState() => ListViewScreenState();
}

class ListViewScreenState extends State<ListViewScreen> {
  Map heading = {};
  List<Model> chaps = [];

  @override
  Widget build(BuildContext context) {
    heading = ModalRoute.of(context)!.settings.arguments as Map;
    String to = "";
    switch (heading['filename']) {
      case "Arati":
        {
          chaps = [
            Model("ದಯಾಮಯ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fdayamaya%20guru.mp3?alt=media&token=fee0470d-19a1-406b-bbe1-d8f33e9e79fe"),
            Model("ಗಂಗಜಟಾಧರ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FHara%20Ganga%20Jatadhara%20Gouri%20Shankara%20(%20256kbps%20cbr%20).mp3?alt=media&token=7da0d3ca-9825-426b-b9ac-7ec896b9f811"),
            Model("ಸಂಜೆ ಆರತಿ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fsai%20baba%20dhoop%20aarti%20(Evening%20Aarti)%20(%20128kbps%20).mp3?alt=media&token=0bee713b-e653-4d2a-89dd-6ba73f8d8ab0"),
            Model("ಮಂಗಳಂ ಗುರು ಶ್ರೀ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FMangalam%20Guru%20Sri%20Chandramouleeshwara%20ke....Arathi%20song%20of%20Shri%20Sringeri%20Jagatguru%20%20parampariya..%20(%20256kbps%20cbr%20).mp3?alt=media&token=ff8c39ab-ef92-4bef-9a68-434ecdf906fa")
          ];
          to = "Music";
        }
        break;
      case "BhajaGurunatham":
        {
          chaps = [
            Model("ಸಖಾರಾಯಪಟ್ಟಣದ ನಾಥನೇ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F1.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ಗುರುನಾಮವೇ ಪಾವನಂ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F2.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ಭಜ ಗುರುನಾಥಮ್",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F3.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ಗುರುನಾಥನೇ ನನ್ನ ಈಶ್ವರ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F4.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ಅರ್ಜುನಂ ಶ್ರೀಧರಂ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F5.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ನಾವು ನೀವು ಸೇರಿ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F6.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b"),
            Model("ನಮ್ಮ ಸದ್ಗುರು ಗುರುನಾಥ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F7.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b")
          ];
          to = "Music";
        }
        break;
      case "Astottara":
        {
          chaps = [
            Model("ಗುರುನಾಥರ ಅಷ್ಟೋತ್ತರ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F1.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9"),
            Model("ಅರ್ಜುನ ಗುರುಗಳ ಅಷ್ಟೋತ್ತರ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F2.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9"),
          ];
          to = "Music";
        }
        break;
      case "BhuvanadaBhagya":
        {
          chaps = [
            Model("ಆರತಿ ಬೆಳಗಿರೋ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F1.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಬಾಬಾ ಬಂದರು ನಮ್ಮ ಮನೆಗೆ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F2.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಭುವನದ ಭಾಗ್ಯ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F3.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ದಿವದಿಂದು ಭೂಮಿಗಿಳಿದು ಬಂದ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F4.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಏನು ಪದವೋ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F5.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಪಾಹಿ ಪಾಹಿ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F6.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಸಾಯಿ ಬಾಬಾ ಸಾಯಿ ಬಾಬಾ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F7.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಸಾಯಿ ಎನ್ನಿರೋ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F8.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
            Model("ಶ್ರೀ ಸಾಯಿ ನಿನ್ನ ನಂಬಿದೆ",
                "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F9.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2"),
          ];
          to = "Music";
        }
        break;
      case "Daily bhajans":
        {
          chaps = [
            Model("ಗೀತಾನಿಕೇತನ ಆಶ್ರಮದ ಪ್ರಾರ್ಥನೆ", "startingshlokas"),
            Model("ಜಯದೇವ (ಶೃಂಗೇರಿ ಮಹಾಸನ್ನಿಧಾನಂ)",
                "jayadevamahasannidhanam"),
            Model("ಜಯದೇವ (ಶ್ರೀಧರ)", "jayadeva_shreedhara"),
            Model("ಗುರುಪಾದುಕಾ ಸ್ತೋತ್ರಂ", "gurupadukastotram"),
            Model("ಗುರುನಾಮಾಮೃತ", "gurunamamruta"),
            Model("ಕಾಯೌ ಶ್ರೀ ಗೌರಿ", "mys_anthem"),
          ];
          to = "ContentView";
          break;
        }
      case "Arti":
        {
          chaps = [
            Model("ಏನು ಪಾದವೋ", "enupadavo"),
            Model("ಸಂಜೆ ಆರತಿ", "evening_arti"),
            Model("ದಯಾಮಯ", "dayamaya"),
            Model("ಗಂಗಾಜಟಾಧರ", "ganga_jatadhara"),
            Model("ಮಂಗಳಂ ಗುರು ಶ್ರೀ", "mangalamgurushree"),
            Model("ಪೂರ್ಣಚಿತ್ ಜ್ಯೋತಿ", "poorna_chitjyoti_chaitaya"),
            Model("ಜ್ಞಾನಪೂರ್ಣ ಜಗಜ್ಯೋತಿ", "gyanpoorna")
          ];
          to = "ContentView";
          break;
        }
      case "Others":
        {
          chaps = [
            Model("ರಾಮ ಬಂದ ಶ್ಯಾಮ ಬಂದ", "ramabanda"),
            Model("ಗುರುಮಹಿಮಾ", "guru_mahima"),
            Model("ಹನುಮಾನ್ ಚಾಲೀಸ್", "hanumanchalisa"),
            Model("ಗುರುವೆ ನಾನು ಒಂದು ಸೊನ್ನೆ", "guruvenaanusonne"),
            Model("ಗುರುವೆ ನಿಮ್ಮಾಜ್ಞೆಯನು", "guruvenimmagneyanu"),
            Model("ಗುರುವೆ ರಾಮ", "guruveraama"),
            Model("ಜೈ ಅವಧೂತ ಗುರು", "jaiavadhutaguru"),
            Model("ಹರಿಮನ", "harimana"),
            Model("ಕದಂಬಗಿರಿಯ", "kadambagiriya"),
            Model("ಕರುಣಾಂತರಂಗ ಗುರುನಾಥ", "karunantaranga"),
            Model("ಗುರುವಿಗೆ ಶರಣಾ ನಾ ಹೋದೆನೆ", "maanikaprabhu"),
            Model("ಮಂದಸ್ಮಿತ ಗುರು ಮನೋಹರಾ", "mandasmitamrudu"),
            Model("ಪಂಡರಾಪುರವೆಂಬ ದೊಡ್ಡ ನಗರ", "pandarapura"),
            Model("ರಾಮಸಾಯಿ ರಾಮಸಾಯಿ", "ramasai"),
            Model("ಸಾಯಿ ಪರಾತ್ಪರ", "saiparatpara"),
            Model("ಶಾರದೆ ಕರುಣಾನಿಧೇ", "sharadekarunanidhe"),
            Model("ಗುರುವಿಗೆ ಶರಣು ನಾ ಹೋದೆನೆ", "guruvigesharana"),
            Model("ಹೇ ಸಾಯಿ ರಾಮ್ ಹೇ ಸಾಯಿ ರಾಮ್", "he sairam"),
            Model("ನಿಮ್ಮಾತ್ಮ ನಿಶ್ಚಲವಿರಲು", "ninnatma nischalaviralu"),
            Model("ರಥವನೇರಿದ ಚಂದ್ರ", "raghavendra rathavanerida chandra"),
            Model("ಶ್ರೀಮತ್ ಚಂದ್ರಶೇಖರ", "shreemat chandrashekhara"),
            Model("ತೇರಾನೇರಿ ಮೆರೆದು ಬರುವ", "teranerimeredu"),
            Model("ಶಕ್ತಿಸಹಿತ ಗಣಪತಿಂ", "shaktisahita ganapatim"),
            Model("ವಿಬುಧಕೀರ್ತಿತಂ", "vibhudhakeertitam"),
            Model("ಶಂಕರಗುರೋ ", "shankaraguru"),
            Model("ಹಾಡಿದರೆ ರಾಮನಾಮ ಹಾಡಲೇಬೇಕು", "hadidare ramanama"),
            Model("ಕೂಸಿನ ಕಂಡೀರಾ ಮುಖ್ಯಪ್ರಾಣನ ಕಂಡೀರಾ", "koosina kandira"),
            Model("ವಂದಿಪೆ ನಿನಗೆ ಗಣನಾಥ", "vandipe ninage"),
            Model("ರಾಮ ರಾಮ ರಾಮನಾಮತಾರಕಂ", "rama rama"),
            Model("ಹರೇ ಮುರಾರೇ ಮಧುಕೈಟಬಾರೇ", "hare murare"),
            Model("ಪ್ರಭು ರಾಮಚಂದ್ರಕೀ ದೂತ", "prabhu ramachadraki doota"),
            Model("ವಿಷ್ಣು ಸಹಸ್ರನಾಮ", "vishnusahas"),
            Model("ಲಲಿತಾ ಸಹಸ್ರನಾಮ", "lalitasahas")
          ];
          to = "ContentView";
          break;
        }

      default:
        {
          for (int i = 0; i <= 36; i++) {
            chaps.add(Model("ಅಧ್ಯಾಯ $i", "chap$i"));
          }
          chaps.add(Model("ಚರಿತ್ರೆಯ ಕುರಿತು".toString(), "chaplast"));
          to = "ContentView";
          break;
        }
    }
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Heading(heading['name'], 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  if (to == "ContentView") {
                    Navigator.pushNamed(context, '/ContentView', arguments: {
                      'name': chaps[index].name,
                      'filename': chaps[index].url,
                    });
                  } else {
                    Navigator.pushNamed(context, '/MusicPLayer', arguments: {
                      'name': chaps[index].name,
                      'url': chaps[index].url,
                      'index': index,
                      'desc': heading['filename'],
                    });
                  }
                },
                title: Text(chaps[index].name),
              ),
            );
          },
          itemCount: chaps.length,
        ),
      ),
    );
  }
}

class Model {
  String name, url;
  Model(this.name, this.url);
}
