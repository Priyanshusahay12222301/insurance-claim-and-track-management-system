enum ClaimStatus {
  draft('Draft'),
  submitted('Submitted'),
  approved('Approved'),
  rejected('Rejected'),
  partiallySettled('Partially Settled');

  final String displayName;
  const ClaimStatus(this.displayName);
}

class Bill {
  final String id;
  final String description;
  final double amount;
  final DateTime date;

  Bill({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  Bill copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
  }) {
    return Bill(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}

class Claim {
  final String id;
  final String patientName;
  final String hospitalName;
  final DateTime admissionDate;
  final DateTime dischargeDate;
  final ClaimStatus status;
  final List<Bill> bills;
  final double advances;
  final double settlements;
  final DateTime createdAt;

  Claim({
    required this.id,
    required this.patientName,
    required this.hospitalName,
    required this.admissionDate,
    required this.dischargeDate,
    required this.status,
    required this.bills,
    required this.advances,
    required this.settlements,
    required this.createdAt,
  });

  Claim copyWith({
    String? id,
    String? patientName,
    String? hospitalName,
    DateTime? admissionDate,
    DateTime? dischargeDate,
    ClaimStatus? status,
    List<Bill>? bills,
    double? advances,
    double? settlements,
    DateTime? createdAt,
  }) {
    return Claim(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      hospitalName: hospitalName ?? this.hospitalName,
      admissionDate: admissionDate ?? this.admissionDate,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      status: status ?? this.status,
      bills: bills ?? this.bills,
      advances: advances ?? this.advances,
      settlements: settlements ?? this.settlements,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'hospitalName': hospitalName,
      'admissionDate': admissionDate.toIso8601String(),
      'dischargeDate': dischargeDate.toIso8601String(),
      'status': status.displayName,
      'bills': bills.map((b) => b.toJson()).toList(),
      'advances': advances,
      'settlements': settlements,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'],
      patientName: json['patientName'],
      hospitalName: json['hospitalName'],
      admissionDate: DateTime.parse(json['admissionDate']),
      dischargeDate: DateTime.parse(json['dischargeDate']),
      status: ClaimStatus.values.firstWhere(
        (s) => s.displayName == json['status'],
        orElse: () => ClaimStatus.draft,
      ),
      bills: (json['bills'] as List).map((b) => Bill.fromJson(b)).toList(),
      advances: json['advances'].toDouble(),
      settlements: json['settlements'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ClaimSummary {
  final double totalBills;
  final double advances;
  final double settlements;
  final double pendingAmount;

  ClaimSummary({
    required this.totalBills,
    required this.advances,
    required this.settlements,
    required this.pendingAmount,
  });
}
