class Overview {
  Overview({
    required this.presentDays,
    required this.totalPaidLeaves,
    required this.totalHolidays,
    required this.totalPendingLeaves,
    required this.totalLeaveTaken,
    required this.total_assigned_projects,
    required this.total_pending_tasks,
    required this.total_awards,
    required this.active_training,
    required this.active_event,
  });

  factory Overview.fromJson(dynamic json) {
    return Overview(
        presentDays: json['present_days'] ?? 0,
        totalPaidLeaves: json['total_paid_leaves'] ?? 0,
        totalHolidays: json['total_holidays'] ?? 0,
        totalPendingLeaves: json['total_pending_leaves'] ?? 0,
        totalLeaveTaken: json['total_leave_taken'] ?? 0,
        total_assigned_projects: json['total_assigned_projects'] ?? 0,
        total_pending_tasks: json['total_pending_tasks'] ?? 0,
        total_awards: json['total_awards'] ?? 0,
        active_training: json['active_training'] ?? 0,
        active_event: json['active_event'] ?? 0);
  }

  int presentDays;
  int totalPaidLeaves;
  int totalHolidays;
  int totalPendingLeaves;
  int totalLeaveTaken;
  int total_assigned_projects;
  int total_pending_tasks;
  int total_awards;
  int active_training;
  int active_event;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['present_days'] = presentDays;
    map['total_paid_leaves'] = totalPaidLeaves;
    map['total_holidays'] = totalHolidays;
    map['total_pending_leaves'] = totalPendingLeaves;
    map['total_leave_taken'] = totalLeaveTaken;
    return map;
  }
}
