class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String passwordHash;
  final String salt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.passwordHash,
    required this.salt,
  });

  bool get isAdmin => role == 'Admin';

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'passwordHash': passwordHash,
        'salt': salt,
      };

  factory AppUser.fromMap(Map<String, Object?> map) => AppUser(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        role: map['role'] as String,
        passwordHash: map['passwordHash'] as String,
        salt: map['salt'] as String,
      );
}