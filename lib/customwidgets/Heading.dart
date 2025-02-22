import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Heading extends StatelessWidget {
  final String name;
  final int i;
  const Heading(this.name, this.i, {super.key});
  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    if (i == 1) {
      color = Colors.black;
    }
    return Text(
      name,
      style: GoogleFonts.poppins(color: color),
      // style: TextStyle(fontFamily: 'Poppins', color: color),
    );
  }
}
