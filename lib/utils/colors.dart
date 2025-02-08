import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static HexColor primaryBlack = HexColor("#000000");
  static Color secondaryBlack = primaryBlack.withAlpha((255 * 0.75).ceil());
  static HexColor primaryWhite = HexColor("#FFFFFF");
  static HexColor primaryGrey = HexColor("#D9D9D9");
  static HexColor primaryBlue = HexColor('#77A1DD');
  static HexColor secondaryBlue = HexColor('#1150AB');
  static HexColor primaryOrange = HexColor('#FF7D3C');
  static HexColor secondaryOrange = HexColor('#FFAA3C');
  static HexColor primaryYellow = HexColor('#FFC73C');
}
