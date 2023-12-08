import 'package:flutter/material.dart';
import 'package:todo_list/Utils/size_config.dart';


class StatusDialog extends StatefulWidget {
  final StatusDialogInterface mListener;

  const StatusDialog(
      {Key key, this.mListener})
      : super(key: key);
  @override
  _StatusDialogState createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  TextEditingController _textController = TextEditingController();
  double textSize;
  double buttonTextSize;
  bool _isButtonTapped = false;

  ScrollController _scrollController = ScrollController();
int selectedValue=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  final List _newData = [
    "Pending",
    "In-progress",
    "Complete",
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Align(
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        child:  Container(
          height: SizeConfig.safeUsedHeight*.35,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius:  BorderRadius.all(Radius.circular(17.0)),
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    getMainContainer(SizeConfig.screenHeight, SizeConfig.screenWidth),
                  ],
                ),
              ),
              getSaveButtonLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            ],
          ),
        ),
      ),
    );
  }



  /* Widget main layout */
  Widget getMainContainer(double parentHeight, double parentWidth) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount:_newData.length,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: GestureDetector(
              onTap: () {
                if(mounted){
                  setState(() {
                    selectedValue = index;
                  });
                }
                if (widget.mListener != null) {
                  widget.mListener
                      .selectedValue(_newData.elementAt(index), index.toString());
                }
                //Navigator.pop(context, true);
              },
              child: Container(
                height: parentHeight*.05,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Text(
                    _newData.elementAt(index),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Raleway_Medium_Font",
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.blockSizeVertical * 2,
                    )),
              ),
            ),
          );
        });
  }
/*Widget for subject field*/
  Widget getSaveButtonLayout(double parentHeight, double parentWidth) {
    return  GestureDetector(
      onTap: () {
        if (!_isButtonTapped) {
          // only allow click if it is false
          _isButtonTapped = true;
          Navigator.pop(context, false); // make it true when clicked
        }

      },onDoubleTap: (){},
      child: Padding(
        padding:  EdgeInsets.only(left: parentWidth*.025,right: parentWidth*.025,bottom: parentHeight*.01),
        child: Container(
          height: parentHeight* 0.065,
          width: parentWidth,
          decoration: BoxDecoration(
            color:Colors.purple,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter_Medium_Font',
                      fontSize: buttonTextSize),
                  textScaleFactor: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class StatusDialogInterface {
  void selectedValue(String selectedValue, String id);
}
