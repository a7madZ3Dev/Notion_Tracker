import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.purple[400]!;
    case 'Food':
      return Colors.red[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.green[400]!;
    default:
      return Colors.orange[400]!;
  }
}