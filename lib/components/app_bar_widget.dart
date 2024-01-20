import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet_app/constant.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color appBarColor;

  const AppBarWidget(
      {super.key, required this.title, required this.appBarColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Constant.darkGray,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
      backgroundColor: appBarColor,
      surfaceTintColor: Colors.transparent,
      // elevation: 10,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
