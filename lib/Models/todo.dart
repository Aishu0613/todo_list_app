class Todo {

  int _id;
  String _title;
  String _description;
  String _status;
  String _time;

  Todo(this._title, this._status,this._time, [this._description] );

  Todo.withId(this._id, this._title, this._status,this._time, [this._description]);

  int get id => _id;

  String get title => _title;
  String get time => _time;

  String get description => _description;

  String get status => _status;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 500) {
      this._description = newDescription;
    }
  }

  set status(String newstatus) {
    this._status = newstatus;
  }
  set time(String time) {
    this._time = time;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['status'] = _status;
    map['time'] = _time;

    return map;
  }

  // Extract a Note object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._status = map['status'];
    this._time = map['time'];
  }
}