class Note {
  final String title;
  final String content;
  final String uid;
  final bool isCompleted;
  final int timeEpoch;

  Note(
      {required this.title,
      required this.content,
      required this.uid,
      required this.isCompleted,
      required this.timeEpoch});

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        uid = json['uid'],
        isCompleted = json['isCompleted'],
        timeEpoch = json['timeEpoch'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'uid': uid,
      'isCompleted': isCompleted,
      'timeEpoch': timeEpoch,
    };
  }
}
