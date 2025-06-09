class User {
  final int? id;
  final String namaPengguna;
  final String email;
  final String kataSandi;
  final String? namaLengkap;
  final String? alamat;
  final String? nomorHp;

  User({
    this.id,
    required this.namaPengguna,
    required this.email,
    required this.kataSandi,
    this.namaLengkap,
    this.alamat,
    this.nomorHp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_pengguna': namaPengguna,
      'email': email,
      'kata_sandi': kataSandi,
      'nama_lengkap': namaLengkap,
      'alamat': alamat,
      'nomor_hp': nomorHp,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      namaPengguna: map['nama_pengguna'],
      email: map['email'],
      kataSandi: map['kata_sandi'],
      namaLengkap: map['nama_lengkap'],
      alamat: map['alamat'],
      nomorHp: map['nomor_hp'],
    );
  }
}
