import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';

import 'AppHelper/networking.dart';
import 'Module/Category_Model.dart';
import 'Module/Product_Model.dart';
import 'api/Api.dart';

class testpage extends StatefulWidget {
  @override
  _testpageState createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  List<CategoryModel> CategoryList = List<CategoryModel>();

  Future<void> getCateg() async {
    final NetworkHelper networkHelper =
        NetworkHelper("${Api().baseURL + 'categ_ids'}");
    final Categorydata = await networkHelper.getdata();
    Categorydata.forEach((data) {
      var model = CategoryModel();
      model.id = data['id'];
      model.name = data['name'];
      // model.images = base64.decode(data['image']);
      if (mounted)
        setState(() {
          CategoryList.add(model);
        });
    });
    // print(CategoryList[1].name);
  }


  @override
  void initState() {
    super.initState();
    getCateg();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          child: ListView.builder(
            itemCount: CategoryList.length ,


            itemBuilder: (context, index) {
              var addtocart = Provider.of<AppProvider>(context);
              addtocart.getProduct(CategoryList[index].id);
              return Column(
                children: [
                  Text(CategoryList[index].name),
                  Container(
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          (Orientation == Orientation.portrait) ? 2 : 3),
                      itemCount:5 ,
                      itemBuilder: (context, index) {
                        return Card(
                          child: new GridTile(
                              footer: new Text(addtocart.ProductList[index].name),
                              child: new Image.memory(
                                  addtocart.ProductList[index].images)), //just for testing, will fill with image later
                        );
                      },
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
