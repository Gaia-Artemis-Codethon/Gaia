import 'package:flutter/material.dart';

class MyTabItem {
 final String title;
 final IconData icon;

 MyTabItem(this.title, this.icon);
}

class Navigation extends StatefulWidget {
 final List<MyTabItem> items;
 final List<Widget> pages;
 const Navigation({Key? key, required this.items, required this.pages})
      : super(key: key);

 @override
 _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
 int _currentIndex = 0;
 void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.pages, // Aquí asignas la lista de páginas
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: widget.items
            .map((item) => BottomNavigationBarItem(
                 icon: Icon(item.icon),
                 label: item.title,
                ))
            .toList(),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
 }
}