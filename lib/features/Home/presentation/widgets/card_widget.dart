import 'package:arjun_guruji/features/Home/models.dart';
import 'package:flutter/material.dart';

class CardHome extends StatelessWidget {
  final Items pagename;
  final double width, height;
  const CardHome({
    super.key,
    required this.pagename,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/${pagename.title}");
      },
      child: AnimatedContainer(
        height: height / 8,
        width: width / 3.5,
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 254, 225, 5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              pagename.img,
              width: width / 10,
            ),
            Text(
              pagename.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
