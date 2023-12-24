import 'package:hive/hive.dart';

import '../models/products.dart';

class HiveBoxes{
  static Box<Products> getData() => Hive.box("hiveDatabase");
}