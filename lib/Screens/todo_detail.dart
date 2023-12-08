import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Utils/size_config.dart';


class TODODetail extends StatefulWidget {
  final Todo model;
  const TODODetail({Key key, this.model}) : super(key: key);

  @override
  State<TODODetail> createState() => _TODODetailState();
}

class _TODODetailState extends State<TODODetail> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Todo Detail')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: SizeConfig.screenHeight*.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: Colors.grey,
              ),
            ),
            child: getDetailsLayout(SizeConfig.screenHeight, SizeConfig.screenWidth)),
      ),
    );
  }

  Widget getDetailsLayout(double parentHeight, double parentWidth){
    return ListView(
      padding: EdgeInsets.only(left: parentWidth*.025,right: parentWidth*.025),
      shrinkWrap: true,
      children: [
        getStatusAndTimerLayout(parentHeight,parentWidth),
        getTitleAndDescriptionLayout(parentHeight,parentWidth),
      ],
    );
  }

  Widget getStatusAndTimerLayout(double parentHeight, double parentWidth){
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: parentHeight* 0.05,
            width: parentWidth*.4,
            decoration: BoxDecoration(
              color:Colors.purple,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
               widget.model.status,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter_Medium_Font',
                  fontSize: SizeConfig.blockSizeVertical * 2,
                    ),
                textScaleFactor: 1.1,
              ),
            ),
          ),
          Container(
            height: parentHeight* 0.05,
            width: parentWidth*.4,
            decoration: BoxDecoration(
              color:Colors.purple,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                widget.model.time,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter_Medium_Font',
                  fontSize: SizeConfig.blockSizeVertical * 2,
                ),
                textScaleFactor: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getTitleAndDescriptionLayout(double parentHeight, double parentWidth){
    return Padding(
      padding:  EdgeInsets.only(top: parentHeight*.02),
      child: Container(
        height: parentHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.model.title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Inter_Medium_Font',
                fontSize: SizeConfig.blockSizeVertical * 2.2,
              ),
              textScaleFactor: 1.1,
            ),
            Padding(
              padding:EdgeInsets.only(top: parentHeight*.01),
              child: Text(
                widget.model.description,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter_Regular_Font',
                  fontSize: SizeConfig.blockSizeVertical * 1.8,
                ),
                textScaleFactor: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }


  
}
