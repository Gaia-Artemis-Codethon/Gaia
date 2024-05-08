import 'dart:ui';

class Owner{
  final String name;
  final Color color;
  final List<int> properties;

  Owner(this.name, this.color, this.properties);

  String getName(){return this.name;}
  Color getColor(){return this.color;}
  List<int> getProperties(){return this.properties;}

  void addProperty(int id){
    this.properties.add(id);
  }
}