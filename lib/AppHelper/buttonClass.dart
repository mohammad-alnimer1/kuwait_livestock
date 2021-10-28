import 'package:flutter/material.dart';
class button extends StatelessWidget {
  const button({this.color,this.buttonName,this.onpress});
  final Color color;
  final String buttonName;
  final Function onpress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      elevation: 5.0,
      child: MaterialButton(
        onPressed:onpress,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          buttonName,style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
