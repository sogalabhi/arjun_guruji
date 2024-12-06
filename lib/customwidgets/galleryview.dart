import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GalleryView extends StatelessWidget {
  List<String> myList = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 1; i <= 25; i++) {
      myList.add(
          "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F" +
              i.toString() +
              ".jpg?alt=media&token=70b2411b-5d8d-4677-9140-99875a18d217");
    }
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10)),
              child: Image.network(
                data,
                width: 50,
              ),
            );
          }).toList()),
    );
  }
}
