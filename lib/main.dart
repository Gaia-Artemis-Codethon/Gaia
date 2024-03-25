import 'package:flutter/material.dart';
import 'components/navigation.dart';
import 'service/supabase.dart';

void main() async {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
 }
}

class MyHomePage extends StatefulWidget {
 const MyHomePage({super.key, required this.title});

 final String title;

 @override
 State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 int _counter = 0;

 void _incrementCounter() {
    setState(() {
      _counter++;
    });
 }

 @override
 Widget build(BuildContext context) {
    // Define la lista de páginas que quieres mostrar
    List<Widget> _pages = [
      Page1(),
      Page2(),
      Page3(),
    ];

    // Define los elementos de la BottomNavigationBar
    List<MyTabItem> _items = [
      MyTabItem('Page 1', Icons.home),
      MyTabItem('Page 2', Icons.search),
      MyTabItem('Page 3', Icons.settings),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Navigation(
        items: _items,
        pages: _pages, // Pasa la lista de páginas al widget Navigation
      ),
    );
 }
}
class Page1 extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return Center(child: Text('Page 1'));
 }
}

class Page2 extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return Center(child: Text('Page 2'));
 }
}

class Page3 extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return Center(child: Text('Page 3'));
 }
}
