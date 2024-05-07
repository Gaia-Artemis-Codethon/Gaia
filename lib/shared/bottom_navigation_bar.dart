import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../pages/map/mapPage.dart';
import '../pages/plant/userPlants.dart';
import '../pages/toDo/toDo.dart';
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
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 70,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(
                index: 0,
                icon: "images/home.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 1,
                icon: "images/todo.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 2,
                icon: "images/planta.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 3,
                icon: "images/mapa.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required int index,
    required String icon,
    required ValueChanged<int> onPressed,
    required int currentIndex,
  }) {
    return IconButton(
      icon: SvgPicture.asset(
        icon,
        width: 30,
        height: 30,
        color: currentIndex == index
            ? OurColors().primaryButton
            : OurColors().navBarDefault,
      ),
      onPressed: () {
        onPressed(index);
      },
    );
  }
}
