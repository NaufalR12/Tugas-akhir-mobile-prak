class Riwayat {
  final int? id;
  final int idPengguna;
  final String nomorResi;
  final String kurir;
  final String status;
  final String tanggal;

  Riwayat({
    this.id,
    required this.idPengguna,
    required this.nomorResi,
    required this.kurir,
    required this.status,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pengguna': idPengguna,
      'nomor_resi': nomorResi,
      'kurir': kurir,
      'status': status,
      'tanggal': tanggal,
    };
  }

  factory Riwayat.fromMap(Map<String, dynamic> map) {
    return Riwayat(
      id: map['id'],
      idPengguna: map['id_pengguna'],
      nomorResi: map['nomor_resi'] ?? '',
      kurir: map['kurir'] ?? '',
      status: map['status'] ?? '',
      tanggal: map['tanggal'] ?? '',
    );
  }
}
