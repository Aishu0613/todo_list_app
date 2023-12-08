import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Screens/status_dialoug.dart';
import 'package:todo_list/Utils/common_wiget.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Utils/size_config.dart';

class TodoDialog extends StatefulWidget {
  final String appBarTitle;
  final Todo todos;

  TodoDialog(this.todos, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return TodoDialogState(this.todos, this.appBarTitle);
  }
}

class TodoDialogState extends State<TodoDialog> with StatusDialogInterface {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Todo todo;
  String statusName = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();
  TimeOfDay _selectTime;
  String newTime= "";
  TodoDialogState(this.todo, this.appBarTitle);
  bool isTimeZoneValidShow = false;
  bool isTimeZoneMsgValidShow = false;
  bool isStatusValidShow = false;
  bool isStatusMsgValidShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(appBarTitle=="Edit Todo"){
      titleController.text = todo.title;
      descriptionController.text = todo.description;
      newTime=todo.time;
      statusName=todo.status;
    }
  descriptionController.addListener(removeErrorOnDescription);
  titleController.addListener(removeErrorOnTitle);
  }

  removeErrorOnTitle() {
    if (titleController.text.isNotEmpty) {
      if (mounted) {
        setState(() {
          isTitleValidShow = false;
          isTitleMsgValidShow = false;
        });
      }
    }
  }

  removeErrorOnDescription() {
    if (descriptionController.text.isNotEmpty) {
      if (mounted) {
        setState(() {
          isDescriptionValid = false;
          isDescriptionMsgValid = false;
        });
      }
    }
  }
  bool isDescriptionValid = false;
  bool isDescriptionMsgValid = false;
  bool isTitleValidShow = false;
  bool isTitleMsgValidShow = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenHeight * .55,
      child: Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.screenHeight * 0.01,
            left: SizeConfig.screenWidth * .04,
            right: SizeConfig.screenWidth * .04),
        child: ListView(
          children: <Widget>[
            getAddTitleLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            getAddDescriptionLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            getStatusLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            getTimeZoneFieldLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
            getButtonLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
          ],
        ),
      ),
    );
  }

  String errorMessageTitle = "More than 255 characters not allowed";
  String errorMessageDescription = "More than 500 characters not allowed";

  /* Widget for Title Layout */
  Widget getAddTitleLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .01),
      child: Container(
        alignment: Alignment.topLeft,
        height: parentHeight * .1,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 1, color: Colors.grey.withOpacity(0.8))),
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(left: parentWidth * .025,),
              child: TextFormField(
                focusNode: _titleFocus,
                // autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                maxLength: 255,
                onEditingComplete: () {
                  _titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(_descFocus);
                },
                controller: titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: parentHeight*.01,bottom: parentHeight*.01),
                  counterText: "",
                  border: InputBorder.none,
                  hintText: "Add title",
                  hintStyle: TextStyle(
                    fontFamily: "Inter_Regular",
                    fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Inter_Regular",
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Visibility(
              visible: isTitleValidShow,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: parentHeight * .04,
                    right: parentWidth * .0),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isTitleMsgValidShow = !isTitleMsgValidShow;
                        });
                      }
                    },
                    onDoubleTap: () {},
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            CommonWidget.getShowError(
              parentHeight * .045,
              parentWidth * .01,
              SizeConfig.blockSizeHorizontal * 2.5,
              isTitleMsgValidShow,
                titleController.text.trim().isEmpty
                    ?  "Please enter comment ":errorMessageTitle,
            ),
          ],
        ),
      ),
    );
  }

  /* Widget for Title Layout */
  Widget getAddDescriptionLayout(double parentHeight, double parentWidth){
    return Padding(
      padding: EdgeInsets.only(top: parentHeight * .01),
      child: Container(
        alignment: Alignment.topLeft,
        height: parentHeight * .2,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 1, color: Colors.grey.withOpacity(0.8))),
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(left: parentWidth * .025),
              child: TextFormField(
                focusNode: _descFocus,
                // autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                maxLength: 500,
                onEditingComplete: () {
                  _descFocus.unfocus();
                },
                controller: descriptionController,
                scrollPadding: EdgeInsets.only(bottom: parentHeight*.2),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: parentHeight*.01,bottom: parentHeight*.01),
                  counterText: "",
                  border: InputBorder.none,
                  hintText: "Enter description",
                  hintStyle: TextStyle(
                    fontFamily: "Inter_Regular",
                    fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Inter_Regular",
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Visibility(
              visible: isDescriptionValid,
              child: Padding(
                padding: EdgeInsets.only(
                    top: parentHeight * .015, right: parentWidth * .01),
                child: Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            isDescriptionMsgValid = !isDescriptionMsgValid;
                          });
                        }
                      },
                      child: const Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            CommonWidget.getShowError(
                parentHeight * .047,
                parentWidth * .01,
                SizeConfig.blockSizeHorizontal * 2.5,
                isDescriptionMsgValid,
              descriptionController.text.trim().isEmpty
                  ?  "Please enter comment ":errorMessageDescription),
          ],
        ),
      ),
    );
  }


  /*Widget for status layout*/
  Widget getStatusLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: ()  {
        FocusScope.of(context).requestFocus(FocusNode());
        if(mounted){
          setState(() {
            isStatusValidShow = false;
            isStatusMsgValidShow = false;
          });
        }
       showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return StatusDialog(
                mListener: this,
              );
            });
      },
      onDoubleTap: () {},
      child: Stack(
        alignment: Alignment.centerRight,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: parentHeight * 0.01,),
            child: Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1, color: Colors.grey.withOpacity(0.8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .04),
                    child: Text(
                      statusName==""?"Select status":statusName,
                      style: TextStyle(
                        color: statusName == ""
                            ? Colors.grey.withOpacity(0.8)
                            : Colors.black,
                        fontFamily: "Roboto_Regular_Font",
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.blockSizeVertical * 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: parentWidth * 0.02),
                    child: Image(
                      image: AssetImage("assets/images/drop_down.png"),
                      height: parentHeight * .035,
                      //color: CommonColor.HINT_TEXT_COLOR.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isStatusValidShow,
            child: Padding(
              padding: EdgeInsets.only(top: parentHeight * 0.00,
                  right: parentWidth * .02),
              child: Container(
                child: GestureDetector(
                    onTap: () {
                      if (mounted)
                        setState(() {
                          isStatusMsgValidShow = !isStatusMsgValidShow;
                        });
                    },
                    onDoubleTap: () {},
                    child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
          ),
          CommonWidget.getShowError(
              parentHeight * .043,
              parentWidth * .01,
              SizeConfig.blockSizeHorizontal * 2.5,
              isStatusMsgValidShow,
              "Please select status"),
        ],
      ),
    );
  }

  /* Widget for Contact Field Layout */
  Widget getTimeZoneFieldLayout(double parentHeight, double parentWidth) {
    return GestureDetector(
      onTap: () async {
        if(mounted){
          setState(() {
            isTimeZoneValidShow = false;
            isTimeZoneMsgValidShow = false;
          });
        }
        final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.grey, // <-- SEE HERE
                  onPrimary: Colors.white, // <-- SEE HERE
                  onSurface: Colors.black, // <-- SEE HERE
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.black, // button text color
                  ),
                ),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: child,
              ),
            );
          },
        );
        final time = picked;
        time.toString();
        newTime = "${time.hour}:${time.minute}";
        //updateTime();
        if (picked != null) {
          setState(() {
            _selectTime = picked;
          });
        }
        },
      onDoubleTap: () {},
      child: Padding(
        padding: EdgeInsets.only(
          top: parentHeight * 0.01,),
        child: Stack(
          alignment: Alignment.centerRight,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: parentHeight * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1, color: Colors.grey.withOpacity(0.8))),
              child: Padding(
                padding: EdgeInsets.only(
                    left: parentWidth * .03, right: parentWidth * .02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      newTime !=""
                          ? newTime
                          : 'Select time',
                      style: TextStyle(
                        fontFamily: 'Inter_Regular_Font',
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color:  newTime !=""
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isTimeZoneValidShow,
              child: Padding(
                padding: EdgeInsets.only(top: parentHeight * 0.00,
                    right: parentWidth * .02),
                child: Container(
                  child: GestureDetector(
                      onTap: () {
                        if (mounted)
                          setState(() {
                            isTimeZoneMsgValidShow = !isTimeZoneMsgValidShow;
                          });
                      },
                      onDoubleTap: () {},
                      child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            CommonWidget.getShowError(
                parentHeight * .043,
                parentWidth * .01,
                SizeConfig.blockSizeHorizontal * 2.5,
                isTimeZoneMsgValidShow,
                "Please select time"),
          ],
        ),
      ),

    );
  }


  Widget getButtonLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(top: parentHeight*.02,left: parentWidth*.03,right: parentWidth*.03),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto_Medium_Font',
                  fontSize: SizeConfig.blockSizeVertical * 2,
                ),
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Save button clicked");
                  _save();
                });
              },
            ),
          ),
          Container(
            width: 5.0,
          ),
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto_Medium_Font',
                  fontSize: SizeConfig.blockSizeVertical * 2,
                ),
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Delete button clicked");
                  Navigator.pop(context, true);
                  // _delete();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the status of todo object
  void updateStatus() {
    todo.status = statusName;
  }

  // Update the time of todo object
  void updateTime() {
    todo.time = newTime;
    print("ghfghfgghfg  ${todo.time}");
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    bool status=true;
    if ( descriptionController.text.trim().isEmpty  || descriptionController.text.length>500) {
      status = false;
      isDescriptionValid = true;
      isDescriptionMsgValid = true;

      if( descriptionController.text.trim().isEmpty ){
        errorMessageDescription = "Please enter description";
      }else if(descriptionController.text.length>500) {
        errorMessageDescription = "More than 500 characters not allowed";
      }
    }
    if ( titleController.text.trim().isEmpty  || titleController.text.length>255) {
      status = false;
      isTitleValidShow = true;
      isTitleMsgValidShow = true;

      if( titleController.text.trim().isEmpty ){
        errorMessageTitle = "Please enter title";
      }else if(titleController.text.length>500) {
        errorMessageTitle = "More than 255 characters not allowed";
      }
      if(statusName==""){
        status = false;

        isStatusValidShow = true;
        isStatusMsgValidShow = true;
      }
      if(newTime==""||newTime==null){
        status = false;
         isTimeZoneValidShow = true;
         isTimeZoneMsgValidShow = true;
      }

    }

    if(status){
      setState(() {
        updateTitle();
        updateDescription();
        updateStatus();
        updateTime();
      });
      moveToLastScreen();

      // todo.date = DateFormat.yMMMd().format(DateTime.now());
      int result;
      if (todo.id != null) {
        // Case 1: Update operation
        result = await helper.updateTodo(todo);
      } else {
        // Case 2: Insert Operation
        result = await helper.insertTodo(todo);
      }

      if (result != 0) {
        // Success
        _showAlertDialog('Status', 'Todo Saved Successfully');
      } else {
        // Failure
        _showAlertDialog('Status', 'Problem Saving Todo');
      }
    }

  }

  void _delete() async {
    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Todo');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void selectedValue(String selectedValue, String id) {
    // TODO: implement selectedValue
    setState(() {
      statusName = selectedValue;
     // updateStatus();
      Navigator.pop(context);
      print("hkgtjhgtgt  $statusName $selectedValue");
    });
  }
}
