import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class Button extends StatelessWidget {
  final bool indicator;
  final String buttonText;
  final Function onTap;
  const Button({
    Key key, this.indicator, this.buttonText,this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        alignment:Alignment.center,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(28),
          gradient: indicator?LinearGradient(
              colors: [
                Colors.blue.shade500,
                Colors.blue.shade800
              ]
          ):LinearGradient(
              colors: [
                CupertinoColors.white,
                Colors.white70,
              ]
          ),
        ),
        child: Text('$buttonText',style: TextStyle(
            fontWeight: FontWeight.w400,fontSize: 18,
            color: indicator?Colors.white:Colors.black45
        ),),
      ),
    );
  }
}

