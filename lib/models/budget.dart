class Budget {
  final int? id;
  final String month;
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double percentageUsed;
  final String status;

  Budget({
    this.id,
    required this.month,
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.percentageUsed,
    required this.status,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      month: json['month'],
      budgetAmount: (json['budgetAmount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      percentageUsed: (json['percentageUsed'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'budgetAmount': budgetAmount,
      'spentAmount': spentAmount,
      'remainingAmount': remainingAmount,
      'percentageUsed': percentageUsed,
      'status': status,
    };
  }

  Budget copyWith({
    int? id,
    String? month,
    double? budgetAmount,
    double? spentAmount,
    double? remainingAmount,
    double? percentageUsed,
    String? status,
  }) {
    return Budget(
      id: id ?? this.id,
      month: month ?? this.month,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      percentageUsed: percentageUsed ?? this.percentageUsed,
      status: status ?? this.status,
    );
  }

  // Helper method to get status color
  int getStatusColor() {
    switch (status.toLowerCase()) {
      case 'over budget':
        return 0xFFE53E3E; // Red
      case 'near limit':
        return 0xFFDD6B20; // Orange
      case 'under budget':
        return 0xFF38A169; // Green
      default:
        return 0xFF718096; // Gray
    }
  }

  // Helper method to get progress color
  int getProgressColor() {
    if (percentageUsed >= 100) {
      return 0xFFE53E3E; // Red
    } else if (percentageUsed >= 80) {
      return 0xFFDD6B20; // Orange
    } else {
      return 0xFF38A169; // Green
    }
  }
} 