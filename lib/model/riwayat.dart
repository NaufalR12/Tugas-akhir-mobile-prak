class Riwayat {
  final int? id;
  final int userId;
  final String noResi;
  final String kurir;
  final String status;
  final String tanggal;

  Riwayat({
    this.id,
    required this.userId,
    required this.noResi,
    required this.kurir,
    required this.status,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'no_resi': noResi,
      'kurir': kurir,
      'status': status,
      'tanggal': tanggal,
    };
  }

  factory Riwayat.fromMap(Map<String, dynamic> map) {
    return Riwayat(
      id: map['id'],
      userId: map['user_id'],
      noResi: map['no_resi'],
      kurir: map['kurir'],
      status: map['status'],
      tanggal: map['tanggal'],
    );
  }
}
