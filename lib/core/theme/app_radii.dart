import 'package:flutter/widgets.dart';

class AppRadii {
  const AppRadii._();

  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;

  static const BorderRadius control = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius bubble = BorderRadius.all(Radius.circular(lg));
}
