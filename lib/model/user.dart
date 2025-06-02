class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? namaLengkap;
  final String? alamat;
  final String? noHp;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.namaLengkap,
    this.alamat,
    this.noHp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'nama_lengkap': namaLengkap,
      'alamat': alamat,
      'no_hp': noHp,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      namaLengkap: map['nama_lengkap'],
      alamat: map['alamat'],
      noHp: map['no_hp'],
    );
  }
} 