import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Screens/todo_detail.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:todo_list/Screens/todo_dialog.dart';
import 'package:sqflite/sqflite.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Todo List')),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', ''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        Todo model=todoList.elementAt(index);
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(model.title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(model.title,
                style: TextStyle(fontWeight: FontWeight.bold
                ),
            maxLines: 2,
            ),
            subtitle: Text(model.description,
            maxLines: 2,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: const Icon(Icons.edit,color: Colors.grey,),
                  onTap: () {
                    navigateToDetail(this.todoList[index], 'Edit Todo');
                    },
                ),
                GestureDetector(
                  child: const Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, todoList[index]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
               Navigator.push(context, MaterialPageRoute(builder: (context) {
             return TODODetail(
            model: model,
          );
        }));
            },
          ),
        );
      },
    );
  }



  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
   // Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
    await showModalBottomSheet(
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(10.0))),
        backgroundColor: Colors.white,
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TodoDialog(
                todo, title
            )));
    // await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return TodoDetail(todo, title);
    // }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }


}