import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final bool centerTitle;
  final Color? iconColor;

  const GradientAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.centerTitle = true,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: title == 'Arjun Guruji' ? 'samarkan' : null,
          color: Colors.white,
          fontSize: title == 'Arjun Guruji' ? 40 : 22,
        ),
      ),
      centerTitle: centerTitle,
      elevation: elevation,
      leading: _buildLeading(context),
      actions: actions,
      iconTheme: IconThemeData(color: iconColor),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 0, 54),
              Color.fromARGB(255, 51, 47, 255),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
