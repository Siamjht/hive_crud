import 'package:hive/hive.dart';
part 'products.g.dart';

@HiveType(typeId: 0)
class Products extends HiveObject{

  @HiveField(0)
  String name;
  @HiveField(1)
  double price;
  @HiveField(2)
  String? description;

  Products({required this.name, required this.price, this.description});
}