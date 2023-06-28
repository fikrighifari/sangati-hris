// ignore_for_file: no_leading_underscores_for_local_identifiers

class ShiftModel {
  ShiftModel({
    required this.status,
    required this.message,
    required this.shiftData,
  });
  late final String? status;
  late final String? message;
  late final ShiftData shiftData;

  ShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shiftData = ShiftData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = shiftData.toJson();
    return _data;
  }
}

class ShiftData {
  ShiftData({
    required this.uid,
    required this.shiftIn,
    required this.shiftOut,
    required this.diffHour,
    required this.radius,
    required this.inLat,
    required this.inLong,
    required this.outLat,
    required this.outLong,
  });
  late final int? uid;
  late final String? shiftIn;
  late final String? shiftOut;
  late final String? diffHour;
  late final String? radius;
  late final String? inLat;
  late final String? inLong;
  late final String? outLat;
  late final String? outLong;

  ShiftData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    shiftIn = json['shiftIn'];
    shiftOut = json['shiftOut'];
    diffHour = json['diffHour'];
    radius = json['radius'];
    inLat = json['inLat'];
    inLong = json['inLong'];
    outLat = json['outLat'];
    outLong = json['outLong'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['shiftIn'] = shiftIn;
    _data['shiftOut'] = shiftOut;
    _data['diffHour'] = diffHour;
    _data['radius'] = radius;
    _data['inLat'] = inLat;
    _data['inLong'] = inLong;
    _data['outLat'] = outLat;
    _data['outLong'] = outLong;
    return _data;
  }
}
