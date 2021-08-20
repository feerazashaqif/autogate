class Visitor {
  final List<String> names;
  final List<String> plates;
  final List<String> datetimes;
  final List<String> hours;
  final List<String> status;

  Visitor({this.names, this.plates, this.datetimes, this.hours, this.status});

  factory Visitor.fromJson(Map<String, dynamic> parsedJson) {
    return Visitor(
      names: parsedJson['names'],
      plates: parsedJson['plates'],
      datetimes: parsedJson['datetimes'],
      hours: parsedJson['hours'],
      status: parsedJson['status'],
    );
  }
}
