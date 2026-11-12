class Award {
  String award_description;
  String award_name;
  String awarded_by;
  String awarded_date;
  String employee_name;
  String gift_description;
  String gift_item;
  int id;
  String image;
  String awardImage;
  String reward_code;

  Award(
      {required this.award_description,
      required this.award_name,
      required this.awarded_by,
      required this.awarded_date,
      required this.employee_name,
      required this.gift_description,
      required this.gift_item,
      required this.id,
      required this.image,
      required this.awardImage,
      required this.reward_code});
}
