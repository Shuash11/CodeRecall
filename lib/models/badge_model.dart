class BadgeModel {
  final int? id;
  final String name;
  final String description;
  final int iconCode;
  final String conditionType;
  final int conditionValue;
  final int isEarned;
  final String? earnedAt;

  BadgeModel({
    this.id,
    required this.name,
    required this.description,
    required this.iconCode,
    required this.conditionType,
    required this.conditionValue,
    this.isEarned = 0,
    this.earnedAt,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      iconCode: map['icon_code'] as int,
      conditionType: map['condition_type'] as String,
      conditionValue: map['condition_value'] as int,
      isEarned: map['is_earned'] as int? ?? 0,
      earnedAt: map['earned_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'icon_code': iconCode,
      'condition_type': conditionType,
      'condition_value': conditionValue,
      'is_earned': isEarned,
      'earned_at': earnedAt,
    };
  }

  BadgeModel copyWith({
    int? isEarned,
    String? earnedAt,
  }) {
    return BadgeModel(
      id: id,
      name: name,
      description: description,
      iconCode: iconCode,
      conditionType: conditionType,
      conditionValue: conditionValue,
      isEarned: isEarned ?? this.isEarned,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}