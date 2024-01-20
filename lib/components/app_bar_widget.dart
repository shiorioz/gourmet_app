import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gourmet_app/constant.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'GOURMET',
        style: TextStyle(
          color: Constant.darkGray,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
      backgroundColor: Constant.blue,
      surfaceTintColor: Colors.white,
      elevation: 10,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // Size get preferredSize => const Size.fromHeight(70);
}
