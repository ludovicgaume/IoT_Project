class Sensors {
  final double distance;

  Sensors({this.distance});

  factory Sensors.fromJson(Map<dynamic, dynamic> json) {
    double parser(dynamic source) {
      try {
        return double.parse(source.toString());
      } on FormatException {
        return -1;
      }
    }

    return Sensors(
        distance: parser(json['distance']));
  }
}