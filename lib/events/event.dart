class Event {

  final int id;
  final String title;
  final String time;
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    return Event(

      id: json["id"],

      title: json["title"],

      time: json["time"],

      location: json["location"],

    );
  }

}