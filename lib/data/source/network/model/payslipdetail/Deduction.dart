class Deduction {
  String amount;
  String name;

  Deduction(
      {required this.amount,
      required this.name,});

  factory Deduction.fromJson(Map<String, dynamic> json) {
    return Deduction(
      amount: json['amount'].toString(),
      name: json['name'].toString(),
    );
  }
}
