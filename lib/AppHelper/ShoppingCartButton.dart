import 'package:flutter/material.dart';
import 'package:kuwait_livestock/nav_bar/Shopping_cart.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';

class shoppingCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<AppProvider>(context);
    counter.getALLProduct();
    return Container(
        child: Stack(
      children: [
        Container(
          width: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
              size: 25,
            ),
          ),
        ),
        Positioned(
            child: Container(
          height: 15,
          width: 15,
          child: Center(
              child: Text(
            '${counter.cartproductmodel.length.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.redAccent,
          ),
        ))
      ],
    ));
  }
}

