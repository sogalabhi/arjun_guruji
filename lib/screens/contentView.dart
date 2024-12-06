import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ContentView extends StatefulWidget {
  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  late IconData data;
  IconData icon = Icons.dark_mode_outlined;
  late Color bgcolor;
  late Color iccolor;
  late int i;
  bool lightmode = false;

  Map heading = {};
  double _value = 10.0;
  String text = "Loading..";

  fetchFileData() async {
    String responseText;
    String fileName = 'raw/${heading['filename']}.txt';
    print(fileName);
    responseText = await rootBundle.loadString(fileName);
    setState(() {
      text = responseText;
    });
  }

  @override
  void initState() {
    super.initState();
    bgcolor = Colors.white;
    iccolor = Colors.black;
    i = 1;
    data = icon;
  }

  @override
  Widget build(BuildContext context) {
    heading = ModalRoute.of(context)!.settings.arguments as Map;
    fetchFileData();
    return Scaffold(
      appBar: AppBar(
        title: Heading(heading['name'], i),
        iconTheme: IconThemeData(
          color: iccolor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: bgcolor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 5 + _value,
                    color: iccolor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (lightmode) {
                        data = Icons.dark_mode_outlined;
                        bgcolor = Colors.white;
                        iccolor = Colors.black;
                        i = 1;
                        lightmode = false;
                      } else {
                        data = Icons.light_mode_outlined;
                        bgcolor = Colors.black;
                        iccolor = Colors.white;
                        i = 0;
                        lightmode = true;
                      }
                    });
                  },
                  child: IconTheme(
                      data: IconThemeData(color: iccolor), child: Icon(data)),
                ),
                Expanded(
                  child: Slider(
                    value: _value,
                    thumbColor: Color.fromARGB(255, 254, 225, 5),
                    inactiveColor: Color.fromARGB(26, 255, 193, 7),
                    secondaryActiveColor: Color.fromARGB(255, 254, 225, 5),
                    activeColor:Color.fromARGB(255, 254, 225, 5),
                    onChanged: (double s) {
                      setState(() {
                        _value = s;
                      });
                    },
                    divisions: 10,
                    min: 10.0,
                    max: 30.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
