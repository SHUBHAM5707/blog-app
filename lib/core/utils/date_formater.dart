import 'package:intl/intl.dart';

String formateDateBydMMMYYY(DateTime dateTime){
  return DateFormat("d MMM YYY").format(dateTime);
}