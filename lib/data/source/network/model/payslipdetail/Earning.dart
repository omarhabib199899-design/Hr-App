class Earning {
  String amount;
  String name;

  Earning(
      {required this.amount,
      required this.name,});

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      amount: json['amount'].toString(),
      name: json['name'].toString(),
    );
  }
}
