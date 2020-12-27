class ServeTime{
  int time_id;
  String start_time;
  String end_time;
  String date;
  int count;

  ServeTime(this.time_id, this.start_time, this.end_time, this.count, this.date);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (time_id != null) {
      map['time_id'] = time_id;
    }
    map['date'] = date;
    map['start_time'] = start_time;
    map['end_time'] = end_time;
    map['count'] = count;

    return map;
  }

  // Extract a Note object from a Map object
  ServeTime.fromMapObject(Map<String, dynamic> map) {
    this.time_id = map['time_id'];
    this.start_time = map['start_time'];
    this.end_time = map['end_time'];
    this.count = map['count'];
    this.date = map['date'];
  }

}