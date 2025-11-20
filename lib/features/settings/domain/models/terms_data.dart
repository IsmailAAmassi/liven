class TermsData {
  const TermsData({
    required this.id,
    required this.htmlContent,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String htmlContent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      id: json['id'] as int? ?? 0,
      htmlContent: json['conditions'] as String? ?? '',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conditions': htmlContent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}
