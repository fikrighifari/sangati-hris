// ignore_for_file: unnecessary_new, no_leading_underscores_for_local_identifiers

class AbsensiOffline {
  AbsensiOffline({
    this.id,
    required this.dayDate,
    required this.statusAbsen,
    required this.waktu,
    required this.inLat,
    required this.inLong,
    required this.fotoUrl,
    required this.status,
    required this.keterangan,
  });
  late final int? id;
  late final String? dayDate;
  late final int? statusAbsen;
  late final String? waktu;
  late final String? inLat;
  late final String? inLong;
  late final String? fotoUrl;
  late final int? status;
  late final String? keterangan;

  AbsensiOffline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayDate = json['dayDate'];
    statusAbsen = json['statusAbsen'];
    waktu = json['waktu'];
    inLat = json['inLat'];
    inLong = json['inLong'];
    fotoUrl = json['fotoUrl'];
    status = json['status'];
    keterangan = json['keterangan'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['dayDate'] = dayDate;
    _data['statusAbsen'] = statusAbsen;
    _data['waktu'] = waktu;
    _data['inLat'] = inLat;
    _data['inLong'] = inLong;
    _data['fotoUrl'] = fotoUrl;
    _data['status'] = status;
    _data['keterangan'] = keterangan;
    return _data;
  }

  toMap() {
    return {
      'dayDate': dayDate,
      'statusAbsen': statusAbsen,
      'waktu': waktu,
      'inLat': inLat,
      'inLong': inLong,
      'fotoUrl': fotoUrl,
      'status': status,
      'keterangan': keterangan,
    };
  }

  AbsensiOffline.fromMap(Map<String?, dynamic> map) {
    id = map['id'];
    dayDate = map['dayDate'];
    statusAbsen = map['statusAbsen'];
    waktu = map['waktu'];
    inLat = map['inLat'];
    inLong = map['inLong'];
    fotoUrl = map['fotoUrl'];
    status = map['status'];
    keterangan = map['keterangan'];
  }
}
