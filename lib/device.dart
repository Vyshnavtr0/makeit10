import 'package:flutter/material.dart';

class DeviceUtils {
  static bool isPhone(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600; // You can adjust this value based on your needs
  }

  static bool isLaptop(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600; // You can adjust this value based on your needs
  }
}
