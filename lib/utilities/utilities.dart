import 'package:intl/intl.dart';

class Utilities {
  static double get padding => 16;
  static double get borderRadius => 24;

    static String timeInDigits(int timestamp) {
    DateFormat format = DateFormat('HH:mm a');
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    return format.format(date);
  }
}
