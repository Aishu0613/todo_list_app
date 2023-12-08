import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonWidget{


  static Widget getShowError(var topMargin,var rightMargin,var fontSize,bool isVis,String errorMsg){
    return Positioned(
      right: rightMargin,
      top: topMargin,
      child: isVis
          ? Container(
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2),width:1),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            errorMsg,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'Avenir_Heavy',
              fontSize: fontSize,
            ),
            textScaleFactor: 1.02,
          ),
        ),
      )
          : Container(),
    );
  }

}