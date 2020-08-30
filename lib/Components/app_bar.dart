import 'package:flutter/material.dart';

AppBar appBar(BuildContext context,String text)
{
  return  AppBar(
    title: Text('$text',
      style: TextStyle(letterSpacing:1.3,fontFamily: 'Dancing',fontWeight: FontWeight.bold),),
  );
}