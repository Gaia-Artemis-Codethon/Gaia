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
        height: 65, // Ajusta esta altura según tus necesidades
        child: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(
                index: 0,
                icon: "images/home-alt-svgrepo-com.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 1,
                icon: "images/task-square-svgrepo-com.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 2,
                icon: "images/plant-pot-svgrepo-com.svg",
                onPressed: onTap,
                currentIndex: currentIndex,
              ),
              _buildNavBarItem(
                index: 3,
                icon: "images/map-location-pin-svgrepo-com.svg",
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
    return GestureDetector(
      onTap: () => onPressed(index),
      child: Container(
        width: 50, // Anchura fija para el contenedor
        height: 50, // Altura fija para el contenedor
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          width: 30, // Nuevo tamaño del icono
          height: 30, // Nuevo tamaño del icono
          color: currentIndex == index
              ? OurColors().primeWhite
              : OurColors().navBarDefault,
        ),
      ),
    );
  }
}
