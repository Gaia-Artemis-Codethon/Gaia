import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedItemColor: OurColors().primaryButton,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: currentIndex == 0
              ? SvgPicture.asset(
                  "images/home.svg",
                  width: 30,
                  height: 30,
                  color: OurColors().primaryButton,
                )
              : SvgPicture.asset(
                  "images/home.svg",
                  width: 30,
                  height: 30,
                ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 1
              ? SvgPicture.asset(
                  "images/todo.svg",
                  width: 30,
                  height: 30,
                  color: OurColors().primaryButton,
                )
              : SvgPicture.asset(
                  "images/todo.svg",
                  width: 30,
                  height: 30,
                ),
          label: 'ToDo',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 2
              ? SvgPicture.asset(
                  "images/planta.svg",
                  width: 30,
                  height: 30,
                  color: OurColors().primaryButton,
                )
              : SvgPicture.asset(
                  "images/planta.svg",
                  width: 30,
                  height: 30,
                ),
          label: 'Plants',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 3
              ? SvgPicture.asset(
                  "images/mapa.svg",
                  width: 30,
                  height: 30,
                  color: OurColors().primaryButton,
                )
              : SvgPicture.asset(
                  "images/mapa.svg",
                  width: 30,
                  height: 30,
                ),
          label: 'Map',
        ),
      ],
    );
  }
}
