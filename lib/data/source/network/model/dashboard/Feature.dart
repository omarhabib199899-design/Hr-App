class Feature {
  Feature({
    required this.name,
    required this.key,
    required this.status,
  });

  factory Feature.fromJson(dynamic json) {
    return Feature(
        name: json['name'].toString(),
        key: json['key'].toString(),
        status: json['status'].toString());
  }

  String name;
  String key;
  String status;
}
