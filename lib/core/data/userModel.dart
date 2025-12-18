class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String? fcmToken;
  final bool notificationEnabled;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.fcmToken,
    required this.notificationEnabled,
  });

  AppUser copyWith({
    bool? notificationEnabled,
    String? fcmToken,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      notificationEnabled:
      notificationEnabled ?? this.notificationEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'notificationEnabled': notificationEnabled,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      fcmToken: map['fcmToken'],
      notificationEnabled: map['notificationEnabled'] ?? true,
    );
  }
}
