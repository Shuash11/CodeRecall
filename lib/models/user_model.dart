class UserModel {
  final int? id;
  final String username;
  final int avatarIndex;
  final int xp;
  final int level;
  final int streakDays;
  final String? lastActiveDate;
  final String createdAt;

  UserModel({
    this.id,
    required this.username,
    this.avatarIndex = 0,
    this.xp = 0,
    this.level = 1,
    this.streakDays = 0,
    this.lastActiveDate,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      username: map['username'] as String,
      avatarIndex: map['avatar_index'] as int? ?? 0,
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      streakDays: map['streak_days'] as int? ?? 0,
      lastActiveDate: map['last_active_date'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'avatar_index': avatarIndex,
      'xp': xp,
      'level': level,
      'streak_days': streakDays,
      'last_active_date': lastActiveDate,
      'created_at': createdAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    int? avatarIndex,
    int? xp,
    int? level,
    int? streakDays,
    String? lastActiveDate,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}