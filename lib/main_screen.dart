import 'package:flutter/material.dart';
import 'bottom_bar.dart';

class MainScreens extends StatelessWidget {
  const MainScreens({Key? key}) : super(key: key);
  static const routeName = '/MainScreen';

  @override
  Widget build(BuildContext context) {
    return const BottomBarScreen();
  }
}
