import 'package:flutter/material.dart';
import 'package:hive_crud/hive_boxes/hive_boxes.dart';
import 'package:hive_crud/models/products.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Hive CRUD"),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveBoxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<Products>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].name.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index].price.toString()),
                              Text(data[index].description.toString()),
                            ],
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                updateData(context, data[index]);
                              },
                              child: Icon(Icons.edit)),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              onTap: () {
                                data[index].delete();
                              },
                              child: Icon(Icons.delete))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Add Product Span
  _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Products"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "products name",
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: "products price",
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: desController,
                    decoration: const InputDecoration(
                      labelText: "products description",
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            final data = Products(
                              name: nameController.text,
                              price:
                                  double.parse(priceController.text.toString()),
                              description: desController.text,
                            );
                            final hiveBox = HiveBoxes.getData();
                            hiveBox.add(data);
                            nameController.clear();
                            priceController.clear();
                            desController.clear();
                          },
                          child: const Text("Add")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  // Update Product Span
  updateData(BuildContext context, Products product) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
    desController.text = product.description ?? "";

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "name"),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "price",
                  ),
                ),
                TextField(
                  controller: desController,
                  decoration: const InputDecoration(
                    labelText: "description",
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          product.name = nameController.text;
                          product.price = double.parse(priceController.text.toString());
                          product.description = desController.text;

                          product.save();

                          nameController.clear();
                          priceController.clear();
                          desController.clear();

                          Navigator.pop(context);
                        }, child: Text("Add"))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
