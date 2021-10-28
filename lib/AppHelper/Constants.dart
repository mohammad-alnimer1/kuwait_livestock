import 'dart:typed_data';

import 'package:flutter/material.dart';

const KDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

  final String  tableCartProduct ='cartProduct';
  final String columnProductId='product_id';
  final String columnName='name';
  final String columnimage='image' ;
  final String columnqnty='product_uom_qty';
  final String columnprice='price_unit';



final String  tableFavoriteProduct ='FavoriteProduct';
final String columnFavoriteId='id';