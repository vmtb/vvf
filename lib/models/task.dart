class Task{
  String userId;
  int time;
  String task;
  String key;
  bool status;

//<editor-fold desc="Data Methods">

  Task({
    required this.userId,
    required this.time,
    required this.task,
    required this.key,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          time == other.time &&
          task == other.task &&
          key == other.key &&
          status == other.status);

  @override
  int get hashCode =>
      userId.hashCode ^
      time.hashCode ^
      task.hashCode ^
      key.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'Task{' +
        ' userId: $userId,' +
        ' time: $time,' +
        ' task: $task,' +
        ' key: $key,' +
        ' status: $status,' +
        '}';
  }

  Task copyWith({
    String? userId,
    int? time,
    String? task,
    String? key,
    bool? status,
  }) {
    return Task(
      userId: userId ?? this.userId,
      time: time ?? this.time,
      task: task ?? this.task,
      key: key ?? this.key,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'time': this.time,
      'task': this.task,
      'key': this.key,
      'status': this.status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      userId: map['userId'] as String,
      time: map['time'] as int,
      task: map['task'] as String,
      key: map['key'] as String,
      status: map['status'] as bool,
    );
  }

//</editor-fold>
}