class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.address,
    required this.status,
    required this.leaveAllocated,
    required this.employmentType,
    required this.userType,
    required this.officeTime,
    required this.branch,
    required this.department,
    required this.post,
    required this.role,
    required this.avatar,
    required this.joiningDate,
    required this.bankName,
    required this.bankAccountNo,
    required this.bankAccountType,
  });

  factory Profile.fromJson(dynamic json) {
    return Profile(
      id: json['id'],
      name: json['name'].toString() ?? "",
      email: json['email'].toString() ?? "",
      username: json['username'].toString() ?? "",
      phone: json['phone'].toString() ?? "",
      dob: json['dob'].toString() ?? "",
      gender: json['gender'].toString() ?? "",
      address: json['address'].toString() ?? "",
      status: json['status'].toString() ?? "",
      leaveAllocated: json['leave_allocated'].toString() ?? "",
      employmentType: json['employment_type'].toString() ?? "",
      userType: json['user_type'].toString() ?? "",
      officeTime: json['office_time'].toString() ?? "",
      branch: json['branch'].toString() ?? "",
      department: json['department'].toString() ?? "",
      post: json['post'].toString() ?? "",
      role: json['role'].toString() ?? "",
      avatar: json['avatar'].toString() ?? "",
      joiningDate: json['joining_date'].toString() ?? "",
      bankName: json['bank_name'].toString() ?? "",
      bankAccountNo: json['bank_account_no'].toString() ?? "",
      bankAccountType: json['bank_account_type'].toString() ?? "",
    );
  }

  int id;
  String name;
  String email;
  String username;
  String phone;
  String dob;
  String gender;
  String address;
  String status;
  String leaveAllocated;
  String employmentType;
  String userType;
  String officeTime;
  String branch;
  String department;
  String post;
  String role;
  String avatar;
  String joiningDate;
  String bankName;
  String bankAccountNo;
  String bankAccountType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['username'] = username;
    map['phone'] = phone;
    map['dob'] = dob;
    map['gender'] = gender;
    map['address'] = address;
    map['status'] = status;
    map['leave_allocated'] = leaveAllocated;
    map['employment_type'] = employmentType;
    map['user_type'] = userType;
    map['office_time'] = officeTime;
    map['branch'] = branch;
    map['department'] = department;
    map['post'] = post;
    map['role'] = role;
    map['avatar'] = avatar;
    map['joining_date'] = joiningDate;
    map['bank_name'] = bankName;
    map['bank_account_no'] = bankAccountNo;
    map['bank_account_type'] = bankAccountType;
    return map;
  }
}
